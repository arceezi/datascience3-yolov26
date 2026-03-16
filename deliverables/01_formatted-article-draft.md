# Detecting Common Road Users in Philippine Traffic: A Comparative YOLOv26 Study

Adviser: John Paul Q. Tomas

## Abstract

Reliable detection of road users in Philippine traffic scenes can support traffic monitoring and other safety-related computer vision tasks. This study evaluated YOLOv26 for detecting seven common road-user classes in Philippine traffic images using a balanced dataset of 1,310 images. Three training configurations were compared in Google Colab by varying optimizer, batch size, learning rate, and epoch count. Model performance was assessed using mAP50, precision, recall, and F1 score. Among the tested configurations, Model_C achieved the strongest validation performance with an mAP50 of 0.6178, precision of 0.6500, recall of 0.5911, and F1 score of 0.6192, outperforming Model_A and Model_B on aggregate metrics. The results indicate that training configuration choice materially influences detection quality for this dataset and that gains are not uniform across classes. These findings provide an initial benchmark for road-user detection in Philippine traffic images and support further work on tighter hyperparameter control, class-specific error analysis, and broader validation before real-world deployment.

## Introduction

Road-user detection is a foundational task in computer vision because it supports higher-level functions such as scene understanding, surveillance, tracking, and intelligent transportation analysis [1,2]. In traffic settings, reliable detection of vehicles and vulnerable road users is important because the visual scene is often crowded, dynamically changing, and affected by occlusion, scale variation, illumination shifts, and camera-related distortion [3-5]. These challenges become especially relevant in heterogeneous urban environments where multiple road-user types occupy the same scene and differ substantially in size, appearance, and motion.

The Philippine traffic context provides a practical and meaningful application setting for this problem. Urban road scenes can contain diverse and visually mixed categories such as bicycles, cars, jeepneys, pedestrians, sport utility vehicles, tricycles, and trucks within the same field of view. This heterogeneity increases the difficulty of detection and creates a useful benchmark for evaluating how a detector behaves across classes that vary in size, shape, and frequency. From a traffic-monitoring perspective, a model that performs well in this setting may support later work in counting, surveillance, and safety-oriented analytics, even if additional validation is still required before operational deployment.

Real-time object detection methods are well suited to this domain because they perform localization and class prediction within a single pipeline [1]. The YOLO family is one of the most widely used examples of this design philosophy, and related studies have shown that YOLO-based approaches remain relevant for traffic-oriented perception tasks because of their balance between speed and accuracy [1,3]. More recent traffic-focused work also shows that urban and fisheye traffic scenes remain difficult because of small objects, clutter, distortion, and class confusion [4,5]. For the present study, YOLOv26 was selected as the experimental detector and trained under three different configurations to examine how optimizer choice, batch size, learning rate, and epoch count affect performance on a Philippine traffic dataset.

This paper does not propose a new detector architecture. Instead, it provides a comparative evaluation of three YOLOv26 training configurations using a balanced dataset of common road users in Philippine traffic scenes. The study aims to identify which tested configuration provides the strongest detection performance and to interpret the observed differences in aggregate and class-specific metrics.

## Results

Three YOLOv26 configurations were evaluated on the same balanced dataset and compared using aggregate validation metrics. Across the tested runs, Model_C produced the strongest overall result, followed by Model_A, while Model_B performed worst on all reported aggregate measures. Table 1 summarizes the comparative performance of the three models.

### Table 1. Comparative Performance of YOLOv26 Model Configurations

| Model | Epochs | Optimizer | Batch Size | Learning Rate | mAP50 | Precision | Recall | F1 Score |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Model_A | 25 | AdamW | 4 | 0.01 | 0.6034 | 0.6682 | 0.5274 | 0.5895 |
| Model_B | 30 | SGD | 20 | 0.001 | 0.4858 | 0.5007 | 0.5029 | 0.5018 |
| Model_C | 40 | auto | auto-batch | 0.0001 | 0.6178 | 0.6500 | 0.5911 | 0.6192 |

Caption note:
- report mAP50, Precision, Recall, and F1 for Model_A, Model_B, and Model_C

Model_C achieved the highest mAP50 (0.6178) and the highest F1 score (0.6192), indicating the best balance between precision and recall among the tested configurations. Model_A produced the highest precision (0.6682), but its lower recall reduced its overall F1 score relative to Model_C. Model_B was the weakest configuration overall, with the lowest mAP50, precision, and F1 score. These aggregate results indicate that the choice of training configuration materially affected detection quality on the present dataset.

Class-wise performance showed uneven behavior across the seven categories. Jeepney was one of the strongest classes across all three models, with F1 scores of 0.7456 for Model_A, 0.6455 for Model_B, and 0.7299 for Model_C. SUV and Truck were also relatively stable for the strongest configuration, with Model_C reaching F1 scores of 0.6607 and 0.6246, respectively. In contrast, Tricycle was consistently the weakest class, with F1 scores of 0.3659, 0.2027, and 0.4168 for Models A, B, and C. Pedestrian and Bicycle showed intermediate behavior, suggesting that some classes remained more difficult than others even when aggregate performance improved.

### Figure 1. Confusion Matrix

Figure placeholder for the selected normalized confusion matrix of the strongest configuration.

Caption. Normalized confusion matrix for the selected YOLOv26 configuration, highlighting class-wise concentration on the diagonal and the remaining error regions for weaker classes.

The confusion matrices provide a visual complement to the metric tables. The selected normalized confusion matrix should highlight the stronger diagonal concentration of the best-performing configuration and the persistent errors associated with weaker categories, especially Tricycle and other visually challenging classes.

### Figure 2. Training Dynamics

Figure placeholder for the selected training loss and metric curves of the strongest configuration.

Caption. Training-dynamics curves for the selected YOLOv26 configuration, summarizing how learning progressed across epochs.

The training-dynamics curves from the run artifacts should be used to show how the selected configuration evolved across epochs and to support the comparison of learning behavior among the three tested setups.

## Discussion

The results show that training configuration choice had a meaningful effect on detection quality, but the present comparison should be interpreted carefully because several hyperparameters were changed at the same time. Model_C differed from the other two runs in optimizer selection, epoch count, learning rate, and batch behavior. As a result, its stronger aggregate performance cannot be attributed to a single factor with certainty. Nevertheless, the outcome still suggests that the Model_C configuration produced a more favorable precision-recall balance on this dataset than the settings used in Models A and B.

One useful contrast is the difference between Model_A and Model_C. Model_A achieved the highest precision, which indicates that it was more conservative and produced fewer false positive detections overall. However, its lower recall limited its F1 score. Model_C, in contrast, maintained competitive precision while substantially improving recall, which led to the highest F1 score among the tested runs. A plausible interpretation is that the smaller learning rate and longer training schedule in Model_C allowed the detector to fit the dataset more gradually and capture additional true positives without a major collapse in precision. This interpretation should remain cautious because the comparison is confounded by simultaneous changes in batch size behavior and optimizer mode.

Model_B provides the clearest negative contrast. Its lower performance across all aggregate metrics suggests that the tested combination of SGD, batch size 20, 30 epochs, and learning rate 0.001 was less suitable for the present dataset than the other two configurations. The result does not imply that SGD is generally inferior; rather, it indicates that this specific configuration underperformed under the current data and training setup.

The class-wise results also reveal important dataset-level and task-level challenges. Tricycle was the weakest class across all three models, with Model_C improving the class only to an F1 score of 0.4168. This persistent weakness suggests that Tricycle instances may be harder to detect because of their smaller visual footprint, structural variability, overlap with other vehicles, or lower representation quality in the dataset. Pedestrian and Bicycle also showed lower scores than the strongest vehicle classes, which is consistent with the broader traffic-detection literature where small, partially occluded, or visually inconsistent objects remain difficult to detect reliably [4,5]. By contrast, Jeepney, SUV, and Truck were comparatively easier for the detector, likely because of stronger shape cues and more stable visual identity in the training images.

Another relevant consideration is the composition of the balanced dataset itself. Although the dataset was augmented to improve class coverage, the notebook outputs show that the training split still retained uneven annotation counts across classes, with an imbalance ratio of 2.93 even after balancing. The training set also combined 705 original images with 305 augmented images, which means some of the apparent balancing benefit may come from synthetic variation rather than from large amounts of new real-world data.

Finally, the study has several practical limitations. The reported best result is based on validation metrics rather than a final held-out test comparison. The three configurations are not controlled one-variable-at-a-time experiments, so fine-grained causal interpretation is limited. In addition, the paper currently evaluates image-based detection results rather than end-to-end video analytics or deployment behavior. For these reasons, Model_C can be treated as the strongest tested configuration in this experiment, but not yet as a deployment-ready solution.

## Methods

### Experimental Environment

All training and evaluation procedures were executed in Google Colab using a Python 3 environment with the Ultralytics package (version 8.4.18) and an NVIDIA Tesla T4 GPU. Google Drive was mounted inside the Colab runtime and used to access the dataset directory and store training outputs.

### Conceptual Framework

The conceptual workflow of the study was straightforward. Traffic-scene images were provided as inputs to a YOLOv26 detector, which was trained to localize and label seven road-user classes through bounding-box prediction and class assignment. The trained models were then evaluated on the validation split using standard object-detection metrics, and the resulting aggregate and class-specific outputs were compared across three training configurations.

### Dataset

The experiment used a balanced dataset stored under the `Balanced` directory in the project dataset workspace. The dataset contained seven object classes: Bicycle, Car, Jeepney, Pedestrian, SUV, Tricycle, and Truck. Based on the notebook outputs, the dataset comprised 1,310 images in total, partitioned into 1,010 training images, 154 validation images, and 146 test images. The training set included 705 original images and 305 augmented images. The notebook also reported residual class imbalance in the training annotations, with class counts ranging from 539 to 1,581 and an imbalance ratio of 2.93.

### Data Configuration

The dataset used a standard YOLO directory structure with `train/images`, `valid/images`, and `test/images` paired with corresponding label folders. During the experiment, the dataset YAML file was configured to point to the balanced dataset root and to use relative paths for the train, validation, and test splits.

### Model And Training Configurations

All three runs used the `yolo26n.pt` weights as the starting model. The input image size was fixed at 640 for all runs, but the optimizer, number of epochs, batch behavior, and initial learning rate varied across configurations.

- Model_A: 25 epochs, AdamW optimizer, batch size 4, learning rate 0.01
- Model_B: 30 epochs, SGD optimizer, batch size 20, learning rate 0.001
- Model_C: 40 epochs, automatic optimizer selection, automatic batch sizing, learning rate 0.0001

Each model was trained through the Ultralytics training procedure with outputs stored under the shared `detect` project directory.

### Evaluation Procedure

After training, each model was evaluated using the Ultralytics validation routine on the validation split. Aggregate metrics recorded in the notebook were mAP50, precision, recall, and F1 score. In addition to aggregate metrics, the workflow also extracted per-class precision, recall, AP50, and F1 score values. These outputs were then assembled into comparison tables and visual summaries for manuscript reporting. Although the dataset contained a separate test split, the reported results in version 1 are based on validation outputs.

## References

1. Redmon J, Divvala S, Girshick R, Farhadi A. You only look once: Unified, real-time object detection. In: Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition; 2016 Jun; Las Vegas, NV, USA. p. 779-788. Available from: https://openaccess.thecvf.com/content_cvpr_2016/html/Redmon_You_Only_Look_CVPR_2016_paper.html

2. Liu L, Ouyang W, Wang X, Fieguth P, Chen J, Liu X, Pietikainen M. Deep learning for generic object detection: A survey. Int J Comput Vis. 2020;128:261-318. Available from: https://doi.org/10.1007/s11263-019-01247-4

3. Wu D, Liao MW, Zhang WT, Wang XG, Bai X, Cheng WQ, Liu WY. YOLOP: You only look once for panoptic driving perception. Mach Intell Res. 2022;19:550-562. Available from: https://doi.org/10.1007/s11633-022-1339-y

4. Luo X, Cui Z, Su F. FE-Det: An effective traffic object detection framework for fish-eye cameras. In: Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition Workshops; 2024 Jun; Seattle, WA, USA. p. 7091-7099. Available from: https://openaccess.thecvf.com/content/CVPR2024W/AICity/html/Luo_FE-Det_An_Effective_Traffic_Object_Detection_Framework_for_Fish-Eye_Cameras_CVPRW_2024_paper.html

5. Soudeep S, Jahin MA, Mridha MF. Interpretable dynamic graph neural networks for small occluded object detection and tracking [Internet]. arXiv [cs.CV]. 2024 [cited 2026 Mar 17]. Available from: https://arxiv.org/abs/2411.17251
