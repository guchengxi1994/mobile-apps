package com.xiaoshuyui.easywork;

import android.content.ContentResolver;
import android.content.Context;
import android.media.RingtoneManager;

import androidx.annotation.NonNull;

import java.util.*;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    final String channel = "xiaoshuyui/easy_work";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channel).setMethodCallHandler(
                (call, result) -> {
                    System.out.println(call.arguments);
                    if ("drawableToUri" == call.method) {
                        int resourceId = this.getResources().getIdentifier((String) call.arguments, "drawable", this.getPackageName());
                        result.success(resourceToUriString(this, resourceId));
                    }
                    if ("getAlarmUri" == call.method) {
                        result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString());
                    }
                }
        );
    }

    private String resourceToUriString(Context context, int resId) {
        return (ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + context.getResources().getResourcePackageName(resId)
                + "/"
                + context.getResources().getResourceTypeName(resId)
                + "/"
                + context.getResources().getResourceEntryName(resId));
    }
}
