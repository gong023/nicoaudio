<?php
/*
 * $dataで指定したアカウントを使用してニコニコ動画へのログインを行い、、GET['id']で指定
 * された動画をサーバにダウンロードした上で、ffmpegまたはswfextractを使用して音声部分を
 * 抽出して、その結果(音声ファイル)をブラウザに返します。
 *
 * 対応する動画はIDがsmまたはnmから始まるsmilevideoに投稿された動画のみで、fzから始まる
 * フォト蔵の動画や、ax、naまたはsoなどの公式動画、数字から始まるチャンネル動画などには
 * 対応していません。(でも多分、数字から始まるIDでも物によっては取得できる)。
 * また、対応する動画形式はmp4、flv、swfで、それぞれ音声部分はaac、mp3、mp3に対応します。
 *
 * 動画と音声はそれぞれサーバの./video/と./audio/にスレッドID.拡張子というファイル名で
 * 保存されます。拡張子は動画ファイルのURLで判断する為、仕様変更があった場合などに利用
 * できなくなります。
 */
//class Nico {
//}

function getVideo($data_id, $data_title) {
error_log('getvideo');

$data = array(
    'mail'     => 'geekmaru@gmail.com',   // ニコニコ動画のログインメールアドレス
    'password' => 'koenji81'    // ニコニコ動画のログインパスワード
);
//$_GET['id'] = 'sm18241904';
$_GET['id'] = $data_id;
// videoidが不正な形式でないか確認
if (!empty($_GET['id']) && ctype_alnum($_GET['id']) ) {
    $videoid = $_GET['id'];    // idが空でなく英数字の場合、そのまま$videoidに代入
} else {
    error_log('Bad videoid.');    // そうでない場合はエラーを表示し終了
}

// API,ログインURL
$api      = "http://ext.nicovideo.jp/api/getflv/{$videoid}?as3=1";
$loginurl = 'https://secure.nicovideo.jp/secure/login?site=niconico';

// プログラムのパス
$ffmpeg     = '/usr/local/bin/ffmpeg';
// $ffmpeg     = 'C:\dev\bin\ffmpeg.exe';
$swfextract = '/usr/local/bin/swfextract';
// $swfextract = 'C:\dev\bin\swfextract.exe';

// 各フォルダのパス。
$tmpdir   = './tmp';    // 一時的にcookieを保存するdir
$videodir = './video';  // DLした動画ファイルを保存するdir
$audiodir = './audio';  // 変換した音声ファイルを保存するdir

// dirが存在しない場合は作成を試みる
if (!file_exists($tmpdir)) {
    if (!mkdir($tmpdir)) {
        // 作成できない場合は終了
        error_log('Failed to create tmpdir');
    }
}

if (!file_exists($videodir)) {
    if (!mkdir($videodir)) {
        error_log('Failed to create videodir');
    }
}

if (!file_exists($audiodir)) {
    if (!mkdir($audiodir)) {
        error_log('Failed to create audiodir');
    }
}

// cookieを一時保存するtmpファイルを作成
$tmp = tempnam($tmpdir, 'NND');    // ./tmpにNNDから始まるtmpファイルを作成
if (!touch($tmp)) {               // ファイルが存在するか確認
    error_log('Failed to create tmp file.');    // ファイルが使用できない場合はエラーを表示し終了
}

// ニコニコ動画にログインする
$ch = curl_init($loginurl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);    // location headerを追う
curl_setopt($ch, CURLOPT_COOKIEJAR, $tmp);   // 受信したCookieをtmpファイルに保存
curl_setopt($ch, CURLOPT_POST, TRUE);        // ログイン情報はPOSTで送信
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);    // 送信する内容$data
// SSL証明書の検証をしない。証明書を入れるのが面倒な時用。
// curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
// curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
// または証明書のパスを指定
// curl_setopt($ch, CURLOPT_CAINFO, 'C:\dev\ca\secure.nicovideo.jp.crt');
curl_exec($ch);        // cURLセッションを実行
curl_close($ch);        // cURLセッションを閉じる

// getflv APIを使って動画情報を取得する
$ch = curl_init($api);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_COOKIEFILE, $tmp);      // $cookieFileに保存されたcookieを送信する
$getflv = curl_exec($ch);           // cURLセッションを実行し、その結果を$getflvに代入
curl_close($ch);


// 一応変数の初期化
$error   = null;
$deleted = null;
$closed  = null;

// getflvで取得したクエリ文字列を変数に代入
parse_str($getflv);

// closed=1はログインができていない
if ($closed === '1') {
    unlink($tmp);
    error_log('Failed login to nicovideo.jp');
}

echo 'LOGIN...';

// 今のところ、getflvでerror=がつくのは動画が存在しない場合のみのはず。。。
// 多分、errorの値も"invalid_thread"しかない。以前は削除された時、ここに
// 削除理由が入ってた(invalid_v1とか)みたいだけど、今はdeletedに入ってる
// ToDo: 気が向いたらきちんと値を確認するように直す。 
if (isset($error)) {
    unlink($tmp);
        error_log('Unknown videoid.');    // $errorがnullではない場合、不正な動画IDと判断して終了
}

// deletedがnullでない場合は取得できない動画。
// 今のところerrorと同じで削除されてない場合はセットされてないはず
if (isset($deleted)) {
    unlink($tmp);
    switch ($deleted) {
        case 1:
                // 投稿ユーザによる削除
            error_log("This video is deleted by user.");

        case 2:
                // 動画情報が取得できない
            error_log("Cannot download the video information.");

        case 3:
                // 運営による削除
            error_log("This video is deleted by niwango(operation company).");

        case 8:
                // 存在しない動画
            error_log('This video is nonexistent.');

        default:
                // 不明なエラー
            error_log('Unknown error. Please let me know this video id.');

    }
}

// watchページのcookieを取得
echo $videoid . PHP_EOL;
$ch = curl_init('http://www.nicovideo.jp/watch/'.$videoid);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_COOKIEFILE, $tmp);
curl_setopt($ch, CURLOPT_COOKIEJAR, $tmp);
curl_exec($ch);
curl_close($ch);

echo 'COOKIE...';

// 動画形式を判別
if (preg_match("/smile\?v=/", $url)) {
echo 'aaa...';
        // v=はflv
    $format = 'flv';
    $aformat = 'mp3';
} elseif (preg_match("/smile\?m=/", $url)) {
echo 'bbb...';
        // m=はmp4
    $format = 'mp4';
    $aformat = 'aac';
    // aacをmp3に変換して出力する場合はmp3にする
    // $aformat = 'mp3';
} elseif (preg_match("/smile\?s=/", $url)) {
echo 'ccc...';
        // s=はswf
    $format = 'swf';
    $aformat = 'mp3';
} else {
echo 'ddd...';
        // その他は不明な形式。smilevideo以外の動画もここ。
    unlink($tmp);
    error_log('Unknown video format. Please let me know this video id.');
}
echo 'eee...';

//$videofile = "{$videodir}/{$thread_id}.{$format}";    //videofileの保存場所と名前
$videofile = "{$videodir}/{$data_title}.{$format}";    //videofileの保存場所と名前
//$audiofile = "{$audiodir}/{$thread_id}.{$aformat}"; // audiofileの保存場所と名前
$audiofile = "{$audiodir}/{$data_title}.{$aformat}"; // audiofileの保存場所と名前
echo 'fff...';

// まず動画ファイルがあるかを確認する。無い場合は取得して音声ファイルの生成。
// ある場合は音声ファイルがあるか確認。無い場合は音声ファイルの生成。
// わざわざ動画ファイルがあるか確認してるのは、元々動画ファイルの取得するだけ
// だった時の名残(最初に動画ファイルの取得だけをするスクリプトを作ってた)。
if (!file_exists($videofile)) {    // 利用可能な動画が無い場合
echo 'ggg...';
    // 動画ファイルの取得
    $fp = fopen($videofile, 'w+');    // $videofileを読み/書きで開く
    if (!$fp) {
        // もし$videofileを開けなかったら終了
        unlink($tmp);
        error_log('Failed to open videofile. line ' . __LINE__);
    }
echo 'hhh...';
    // 動画ファイルの取得/保存
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_HTTPGET, true);    // GETでリクエスト。多分、無くてもいい。
    curl_setopt($ch, CURLOPT_COOKIEFILE, $tmp);
    curl_setopt($ch, CURLOPT_FILE, $fp);    // $fp($videofile)に保存
echo 'hii...';
    curl_exec($ch);
    curl_close($ch);
    fclose($fp);    // $videofileを閉じる
    unlink($tmp);    // cookieを削除
echo 'hij...';
    if (is_readable($videofile)) {
echo 'iii...';
        // videoから音声を抽出
        switch($format){
            case 'flv':
                // そのまま抽出するだけの時はflvもmp4も同じ
                // exec("{$ffmpeg} -i {$videofile} -acodec copy {$audiofile}");
                // break;

            case 'mp4':
                // aacをmp3に変換して出力するなら"-acodec libmp3lame"にする。
                // exec("{$ffmpeg} -i {$videofile} -acodec libmp3lame {$audiofile}");
                // mp3に変換して出力する時は$aformatをmp3にしとかないとエラーがでる。
                exec("{$ffmpeg} -i {$videofile} -acodec copy {$audiofile}");
                break;

            case 'swf':
                // swfextract -m [input] -o [output]
                // -m 音声ストリームを抽出する(--mp3)
                exec("{$swfextract} -m {$videofile} -o {$audiofile}");
                break;

            default:
                // 通常はここにたどり着く事は無いはず。
                error_log('Impossible error. line ' . __LINE__);
                break;

        }
        if (!is_readable($audiofile) ) {
echo 'jjj...';
            // 音声ファイルが開けない場合は終了
            error_log('Failed to open audiofile. line ' . __LINE__);
        }
    } else {
        // 動画ファイルが開けない場合は終了
        error_log('Failed to open videofile. line '  . __LINE__);
    }
    echo 'VIDEO...';
} else {    // 動画ファイルが存在する場合
    unlink($tmp);    // cookieを削除
    if (is_readable($videofile)) {    // 読み込み可能な動画ファイルが存在する場合
        if (!file_exists($audiofile)) {    // 音声ファイルが存在しない場合
            // 動画から音声を抽出
            switch($format){
                case 'flv':
                    // そのまま抽出するだけの時はflvもmp4も同じ
                    // exec("{$ffmpeg} -i {$videofile} -acodec copy {$audiofile}");
                    // break;

                case 'mp4':
                    // exec("{$ffmpeg} -i {$videofile} -acodec libmp3lame {$audiofile}");
                    exec("{$ffmpeg} -i {$videofile} -acodec copy {$audiofile}");
                    break;

                case 'swf':
                    exec("{$swfextract} -m {$videofile} -acodec copy {$audiofile}");
                    break;

                default:
                    error_log('Impossible error. line '  . __LINE__);
                    break;

            }
            if (!is_readable($audiofile)) {
                // 音声ファイルを読み込めない場合は終了
                error_log('Filed to open audiofile. line ' . __LINE__);
            }
        } elseif (!is_readable($audiofile)) {
            error_log('Filed to open audiofile. line ' . __LINE__);
        }
    } else {
        // 動画ファイルを開けない場合は終了
        error_log('Failed to open video file. line ' . __LINE__);
    }
    echo 'AUDIO...';
}

// 音声ファイルをダウンロードさせる
header('Content-Type: Application/octet-stream');
header('Content-Disposition: attachment; filename='.basename($audiofile));
header('Content-Length: '.filesize($audiofile));
readfile($audiofile);
error_log;
}
