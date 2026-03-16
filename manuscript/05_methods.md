# 05 Methods

### Experimental Environment

All training and evaluation procedures were executed in Google Colab using a Python 3 environment with the Ultralytics package (version 8.4.18) and an NVIDIA Tesla T4 GPU. Google Drive was mounted inside the Colab runtime and used to access the dataset directory and store training outputs. This setup allowed the experiment to use cloud GPU acceleration while preserving the dataset and run artifacts in a shared project workspace.

### Conceptual Framework

The conceptual workflow of the study was straightforward. Traffic-scene images were provided as inputs to a YOLOv26 detector, which was trained to localize and label seven road-user classes through bounding-box prediction and class assignment. The trained models were then evaluated on the validation split using standard object-detection metrics, and the resulting aggregate and class-specific outputs were compared across three training configurations.

### Dataset

The experiment used a balanced dataset stored under the `Balanced` directory in the project dataset workspace. The dataset contained seven object classes: Bicycle, Car, Jeepney, Pedestrian, SUV, Tricycle, and Truck. Based on the notebook outputs, the dataset comprised 1,310 images in total, partitioned into 1,010 training images, 154 validation images, and 146 test images. The training set included both original and augmented images. Specifically, 705 training images were original samples and 305 were augmentation-derived samples. The notebook also reported residual class imbalance in the training annotations, with class counts ranging from 539 to 1,581 and an imbalance ratio of 2.93, indicating that the balanced dataset improved but did not eliminate class frequency differences.

### Data Configuration

The dataset used a standard YOLO directory structure with `train/images`, `valid/images`, and `test/images` paired with corresponding label folders. During the experiment, the dataset YAML file was configured to point to the balanced dataset root and to use relative paths for the train, validation, and test splits. This ensured compatibility with the Ultralytics training and validation workflow inside the Colab environment.

### Model And Training Configurations

All three runs used the `yolo26n.pt` weights as the starting model. The input image size was fixed at 640 for all runs, but the optimizer, number of epochs, batch behavior, and initial learning rate varied across configurations.

- Model_A: 25 epochs, AdamW optimizer, batch size 4, learning rate 0.01
- Model_B: 30 epochs, SGD optimizer, batch size 20, learning rate 0.001
- Model_C: 40 epochs, automatic optimizer selection, automatic batch sizing, learning rate 0.0001

Each model was trained through the Ultralytics `train` procedure with outputs stored under the shared `detect` project directory. The notebook retained the default training plots and confusion matrices produced by the framework for later interpretation.

### Evaluation Procedure

After training, each model was evaluated using the Ultralytics validation routine on the validation split. Aggregate metrics recorded in the notebook were mAP50, precision, recall, and F1 score. The F1 score was computed from precision and recall. In addition to aggregate metrics, the workflow also extracted per-class precision, recall, AP50, and F1 score values. These outputs were then assembled into comparison tables and visualization-ready summaries for manuscript reporting.

Although the dataset contained a separate test split, the current reported results in version 1 are based on the validation outputs documented in the notebook. Accordingly, the present paper treats the reported values as comparative validation results rather than as a final deployment-grade benchmark.
