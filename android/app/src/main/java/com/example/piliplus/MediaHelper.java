/*
 * Copyright 2018 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.piliplus;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.session.PlaybackState;
import android.os.Build;
import android.view.KeyEvent;

class MediaHelper {
    static PendingIntent buildMediaButtonPendingIntent(Context context, int action) {
        int keyCode = PlaybackStateCompat_toKeyCode(action);
        Intent intent = new Intent(context, com.ryanheise.audioservice.MediaButtonReceiver.class);
        intent.setAction(Intent.ACTION_MEDIA_BUTTON);
        intent.putExtra(Intent.EXTRA_KEY_EVENT, new KeyEvent(KeyEvent.ACTION_DOWN, keyCode));
        intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
        return PendingIntent.getBroadcast(context, keyCode, intent,
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S ? PendingIntent.FLAG_MUTABLE : 0);
    }

    private static int PlaybackStateCompat_toKeyCode(int action) {
        return switch (action) {
            case (int) PlaybackState.ACTION_STOP -> KeyEvent.KEYCODE_MEDIA_STOP;
            case (int) PlaybackState.ACTION_PAUSE -> KeyEvent.KEYCODE_MEDIA_PAUSE;
            case (int) PlaybackState.ACTION_PLAY -> KeyEvent.KEYCODE_MEDIA_PLAY;
            case (int) PlaybackState.ACTION_REWIND -> KeyEvent.KEYCODE_MEDIA_REWIND;
            case (int) PlaybackState.ACTION_SKIP_TO_PREVIOUS -> KeyEvent.KEYCODE_MEDIA_PREVIOUS;
            case (int) PlaybackState.ACTION_SKIP_TO_NEXT -> KeyEvent.KEYCODE_MEDIA_NEXT;
            case (int) PlaybackState.ACTION_FAST_FORWARD -> KeyEvent.KEYCODE_MEDIA_FAST_FORWARD;
            case (int) PlaybackState.ACTION_PLAY_PAUSE -> KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE;
            default -> KeyEvent.KEYCODE_UNKNOWN;
        };
    }

}
