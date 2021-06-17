import json
import time
import torch
import torchvision
import cv2
import numpy as np
from flask import Flask, request
from flask_cors import CORS
import traceback
import base64

# __cache_folder__ = 'D:\\mobile-apps\\image_similarity_demo\\server\\cache\\'

__cache_folder__ = 'D:\\github_repo\\mobile-apps\\image_similarity_demo\\server\\cache\\'

#导入三个算子
toTensor_operator = torchvision.transforms.ToTensor(
)  #将处于[0,255]范围内的灰度值归一化为[0,1]
normalize_operator = torchvision.transforms.Normalize(
    mean=[0.485, 0.456, 0.406], std=[0.229, 0.224,
                                     0.225])  #imagenet数据集上预训练模型需要的归一化参数
scaler_operator = torchvision.transforms.Scale((224, 224))  #尺寸缩放


def _load_model():
    model = torchvision.models.resnet34(pretrained=True)

    # for test
    # for child in model.children():
    #     print(child)

    model.eval()
    return model


def _extract_feature(net, img):
    assert type(img) is np.ndarray, "input error,{}".format(type(img))
    img = cv2.resize(img, (224, 224))

    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    input_data = normalize_operator(toTensor_operator(img)).float()

    input_data = input_data.unsqueeze(0)

    layer = net._modules.get('avgpool')
    #下面几行代码运用了pytorch的hook机制
    #hook机制简单的说就是对一些变量或层做一些额外的事情，这些额外的事情用户可以自己定义
    #此处，需要对提取的特征层layer做额外工作，做的额外工作由copy_data函数定义
    #先定义一个变量用来拷贝layer的输出
    feature = torch.zeros((1, 512, 1, 1))

    #定义函数将layer层的输出数据拷贝到feature
    def copy_data(m, i, o):
        feature.copy_(o.data)

    #将copy_data注册到layer层，即告诉layer层，除了正常的前向运算以外，还需要将输出拷贝到feature中，如果没有这个机制，则整个网络前向运算结束之后，layer的输出数据会释放掉
    h = layer.register_forward_hook(copy_data)
    net(input_data)
    h.remove()
    return feature


#两个特征向量求取cos距离
def cosin_features(feature1, feature2) -> float:
    # print(feature1.squeeze(0).squeeze(-1).squeeze(-1).shape)
    # print(feature2.squeeze(0).squeeze(-1).squeeze(-1).shape)
    feature1 = np.array(feature1.squeeze(0).squeeze(-1).squeeze(-1),
                        dtype=np.float32)
    feature2 = np.array(feature2.squeeze(0).squeeze(-1).squeeze(-1),
                        dtype=np.float32)

    norm1 = np.linalg.norm(feature1)
    norm2 = np.linalg.norm(feature2)
    # print(norm1.shape)
    # print(norm2.shape)
    similarity = np.dot(feature1, feature2.T) / (norm1 * norm2)
    return similarity


net = _load_model()


def _test():
    global net
    img1 = cv2.imread("D:\\workspace\\simnet\\t1_1.jpg")
    img2 = cv2.imread("D:\\workspace\\simnet\\t2_1.jpg")
    img3 = cv2.imread("D:\\workspace\\simnet\\t3_1.jpg")
    # img4 = cv2.imread("D:\\workspace\\simnet\\3.png")
    f1 = _extract_feature(net, img1)
    f2 = _extract_feature(net, img2)
    f3 = _extract_feature(net, img3)
    # f4 = _extract_feature(net, img4)

    print(cosin_features(f1, f2))
    # print(cosin_features(f1, f1))
    print(cosin_features(f1, f3))
    print(cosin_features(f3, f2))
    # print(cosin_features(f1, f4))


app = Flask(__name__)
CORS(app, supports_credentials=True)


@app.route('/', methods=['GET'])
def test():
    """测试用接口
    """
    return "Hello Task Network"


@app.route('/compare', methods=['POST'])
def compare():
    """测试用接口
    """
    res = dict()
    # print(request.data)
    a = request.get_data()
    # print(a)
    try:
        # da = str(request.data).replace("'","")[1:]
        # if type(a) is bytes:
        #     a = a.decode("utf-8")
        # print(type(a))
        # print(a)
        dict1 = json.loads(a)
        # print(dict1)
        data1 = dict1.get('image1', None)
        data2 = dict1.get('image2', None)
        # print(data2)
        if data1 is not None and data2 is not None:
            filename1 = str(time.time()).replace(".", "") + ".jpg"
            filename2 = str(time.time()).replace(".", "") + "_1" + ".jpg"

            f = open(__cache_folder__ + filename1, "wb")
            f.write(base64.b64decode(data1))
            f.close()

            f = open(__cache_folder__ + filename2, "wb")
            f.write(base64.b64decode(data2))
            f.close()

            global net
            img1 = cv2.imread(__cache_folder__ + filename1)
            img2 = cv2.imread(__cache_folder__ + filename2)
            f1 = _extract_feature(net, img1)
            f2 = _extract_feature(net, img2)
            res['code'] = 200
            res['similarity'] = float(cosin_features(f1, f2))

        else:
            print("图片有问题")
            res['code'] = 500
            res['similarity'] = -1
    except:
        traceback.print_exc()
        res['code'] = 500
        res['similarity'] = -1
    return json.dumps(res)


if __name__ == "__main__":
    # _test()
    app.run(host="0.0.0.0", port=3334, debug=True)
