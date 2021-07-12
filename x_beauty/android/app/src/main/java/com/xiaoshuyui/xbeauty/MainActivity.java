package com.xiaoshuyui.xbeauty;

import android.graphics.Bitmap;
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
                    System.out.println(call.arguments);
                    if (call.method != null) {
                        result.success(convert((String) call.argument("filename"), call.argument("type")));
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }


    private String convert(String imgpath, int type) {
        _bitmap = null;
        module = null;
        System.out.println(type);
        String filepath = this.getFilePath(imgpath);
        long timecurrentTimeMillis = System.currentTimeMillis();
        if (type == 0) {
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

            ImageUtil.saveBitmap(resultBitmap, filepath + String.format("/%s.png", timecurrentTimeMillis));

        } else {
            module = PyTorchAndroid.loadModuleFromAsset(getAssets(), "line_face.pt");
            _bitmap = ImageUtil.zoomBitmap(256, 256, imgpath);
            System.out.println("start converting");
            Tensor inputTensor = TensorImageUtils.bitmapToFloat32Tensor(_bitmap, TensorImageUtils.TORCHVISION_NORM_MEAN_RGB, TensorImageUtils.TORCHVISION_NORM_STD_RGB);
            final IValue[] outputTuple = module.forward(IValue.from(inputTensor)).toTuple();

            final Tensor outputTensor = outputTuple[0].toTensor();
            float[] imgArray = outputTensor.getDataAsFloatArray();
            Bitmap resultBitmap = ImageUtil.bitmapFromRGBImageAsFloatArray(imgArray, 256, 256);
            resultBitmap = ImageUtil.adjustPhotoRotation(resultBitmap, 90);

            module = null;
            module = PyTorchAndroid.loadModuleFromAsset(getAssets(), "pencil_face.pt");
            inputTensor = TensorImageUtils.bitmapToFloat32Tensor(resultBitmap, TensorImageUtils.TORCHVISION_NORM_MEAN_RGB, TensorImageUtils.TORCHVISION_NORM_STD_RGB);
            final IValue[] outputTuple2 = module.forward(IValue.from(inputTensor)).toTuple();
            final Tensor outputTensor2 = outputTuple2[0].toTensor();
            float[] imgArray2 = outputTensor2.getDataAsFloatArray();
            Bitmap resultBitmap2 = ImageUtil.bitmapFromRGBImageAsFloatArray(imgArray2, 256, 256);
            resultBitmap2 = ImageUtil.adjustPhotoRotation(resultBitmap2, 90);
            System.out.println("finish converting");

            ImageUtil.saveBitmap(resultBitmap2, filepath + String.format("/%s.png", timecurrentTimeMillis));
        }

        return filepath + String.format("/%s.png", timecurrentTimeMillis);

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