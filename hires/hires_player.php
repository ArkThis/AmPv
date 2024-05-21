#!/bin/env php
<?php 

/**
 * This code expects to be called with a full hires URL including query
 * parameters to hand over to the player.
 *
 * Example:
 * URL: hires://@video-cube1/dva-profession/workflow/03-capture_export2/final/dva-00003/hires/dva-00003-000.mkv?start=0:00:04.19&pause
 */

$profile = 'dva-profession';    // MPV config profile to load/use.
$debug = false;                 // Set to 'true' for verbose information.
$mpv_bin = "mpv";
$URL = $argv[1];                // 1st argument to this script is a video-file URL.
$parts = parse_url($URL);

// Default options:
$player_opts = array();         // Array with arguments/options to pass on to the player.
$player_opts[] = "--ontop";                 // Stay above all other windows.
$player_opts[] = "--profile=".$profile;     // Load config profile for this job.

// --------------------------------------

if ($debug) {                   // DEBUG
    printf("URL: %s\n", $URL);
    print_r($parts);
}

// Get the named=value parameters after the '?', separated by '&':
$params = array();
parse_str($parts['query'], $params);


/**
 * Set player arguments.
 *
 * Add more options however needed. This is where you translate from URL
 * parameters to player options/syntax.
 */
function set_player_options($params, $player_opts)
{
    // Playback offset:
    if (isset($params['start'])) {
        $player_opts[] = "--start=".$params['start'];
    }

    // Start in paused mode:
    if (isset($params['pause'])) {
        $player_opts[] = "--pause";
    }

    return $player_opts;
}


// Put together the actual video URL:
// NOTE: This requires guest (!) read-only access to the Samba/CIFS share.
//       This works, and if so it allows any DVA video to be opened from any
//       other machine within the DVA-Profession network environment.

//DEBUG: Use this line to override the hostname read from the URL:
//$parts['host'] = 'video-cubeX'

$video = "smb://".$parts['user']."@".$parts['host'].$parts['path'];
if ($debug) { printf("Video file: %s\n", $video); }

// The command to call the player with:
$player_opts_str = implode(' ', set_player_options($params, $player_opts));
$cmd="$mpv_bin $player_opts_str $video";
if ($debug) { echo "$cmd"; }

// Start the player / run the command:
if (passthru($cmd, $result_code) === false) {
    printf("Error (%d) running command: %s", $result_code, $cmd);
    sleep(5);
}

if ($debug) {
    sleep(20);      // Keeps the shell-window open to see possible errors.
}

exit;
?>
