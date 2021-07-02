package com.xiaoshuyui.xbeauty;

import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.StrictMode;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

import org.pytorch.IValue;
import org.pytorch.Module;
import org.pytorch.PyTorchAndroid;
import org.pytorch.Tensor;
import org.pytorch.torchvision.TensorImageUtils;

import com.xiaoshuyui.xbeauty.utils.ImageUtil;

public class MainActivity extends FlutterActivity {
    private static final String channel = "face.convert";
    private Module module;
    private Bitmap _bitmap = null;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        System.out.println("balabaka");

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), channel).setMethodCallHandler(
                (call, result) -> {
                    _bitmap = null;
                    module = null;
                    if (call.method != null) {
                        result.success(convert((String) call.arguments));
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }


    private String convert(String imgpath) {
        _bitmap = null;
        String filepath = this.getFilePath(imgpath);
        module = PyTorchAndroid.loadModuleFromAsset(getAssets(), "test.pt");
        System.out.println("start converting");
        System.out.println(imgpath);
        _bitmap = ImageUtil.zoomBitmap(256, 256, imgpath);
        System.out.println("start converting");
        Tensor inputTensor = TensorImageUtils.bitmapToFloat32Tensor(_bitmap, TensorImageUtils.TORCHVISION_NORM_MEAN_RGB, TensorImageUtils.TORCHVISION_NORM_STD_RGB);
        final IValue[] outputTuple = module.forward(IValue.from(inputTensor)).toTuple();
        System.out.println("finish converting");
        final Tensor outputTensor = outputTuple[0].toTensor();
        float[] imgArray = outputTensor.getDataAsFloatArray();
        Bitmap resultBitmap = ImageUtil.bitmapFromRGBImageAsFloatArray(imgArray, 256, 256);
        resultBitmap = ImageUtil.adjustPhotoRotation(resultBitmap, 90);

        long timecurrentTimeMillis = System.currentTimeMillis();

        ImageUtil.saveBitmap(resultBitmap, filepath +  String.format("/%s.png",timecurrentTimeMillis) );
        return filepath + String.format("/%s.png",timecurrentTimeMillis);
    }

    private static String getFilePath(String filename) {
        String filepath = "";
        String[] tmp = filename.trim().split("/");
        for (int i = 1; i < tmp.length - 1; i++) {
            filepath += "/" + tmp[i];
        }
        System.out.println("filepath:" + filepath);
        return tmp[0] + filepath;
    }
}