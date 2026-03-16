# 03 Results

Three YOLOv26 configurations were evaluated on the same balanced dataset and compared using aggregate validation metrics. Across the tested runs, Model_C produced the strongest overall result, followed by Model_A, while Model_B performed worst on all reported aggregate measures. Table 1 summarizes the comparative performance of the three models.

| Model | Epochs | Optimizer | Batch Size | Learning Rate | mAP50 | Precision | Recall | F1 Score |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Model_A | 25 | AdamW | 4 | 0.01 | 0.6034 | 0.6682 | 0.5274 | 0.5895 |
| Model_B | 30 | SGD | 20 | 0.001 | 0.4858 | 0.5007 | 0.5029 | 0.5018 |
| Model_C | 40 | auto | auto-batch | 0.0001 | 0.6178 | 0.6500 | 0.5911 | 0.6192 |

Model_C achieved the highest mAP50 (0.6178) and the highest F1 score (0.6192), indicating the best balance between precision and recall among the tested configurations. Model_A produced the highest precision (0.6682), but its lower recall reduced its overall F1 score relative to Model_C. Model_B was the weakest configuration overall, with the lowest mAP50, precision, and F1 score. These aggregate results indicate that the choice of training configuration materially affected detection quality on the present dataset.

Class-wise performance showed uneven behavior across the seven categories. Jeepney was one of the strongest classes across all three models, with F1 scores of 0.7456 for Model_A, 0.6455 for Model_B, and 0.7299 for Model_C. SUV and Truck were also relatively stable for the strongest configuration, with Model_C reaching F1 scores of 0.6607 and 0.6246, respectively. In contrast, Tricycle was consistently the weakest class, with F1 scores of 0.3659, 0.2027, and 0.4168 for Models A, B, and C. Pedestrian and Bicycle showed intermediate behavior, suggesting that some classes remained more difficult than others even when aggregate performance improved.

The confusion matrices provide a visual complement to the metric tables. Figure 1 should present the normalized confusion matrix for the selected best model, with supporting reference to the other runs when needed. In the current results, the class-wise metric pattern suggests a cleaner diagonal structure for the stronger configuration and persistent confusion for weaker classes, particularly Tricycle and other visually challenging categories.

Figure 1. Normalized confusion matrix for the selected YOLOv26 configuration. The matrix should be used to highlight class-wise concentration on the diagonal and persistent error regions for weaker categories.

Training-dynamics curves from the run artifacts should be presented in Figure 2. These curves are useful for showing how the selected configuration evolved during training and for visually comparing learning behavior across epochs. For version 1, the figure should be inserted from the corresponding run outputs in `DataSci3_Runs/detect/`.

Figure 2. Training-dynamics curves for the selected YOLOv26 configuration. The figure should summarize loss and metric progression across training epochs and support the narrative comparison of learning behavior.
