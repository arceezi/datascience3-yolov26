# 03 Evidence Map

Use this file to connect each paper claim to a concrete source.

Suggested mapping structure:
- claim
- supporting notebook cell, figure, table, or Drive artifact
- exact metric or observation
- section where the claim will appear

Known experiment evidence already available:
- aggregate comparison table for Model_A, Model_B, and Model_C
- per-class metrics table
- confusion matrices for each model
- training output artifacts inside `DataSci3_Runs/detect/Model_*`
- dataset composition details from the notebook and shared Drive layout

Current evidence anchors for title and abstract work:
- study context: common road users in Philippine traffic images
- model family: YOLOv26
- compared configurations: three training setups labeled Model_A, Model_B, and Model_C
- class count: 7 classes
- dataset size from notebook outputs:
  - train: 1010 images
  - valid: 154 images
  - test: 146 images
  - total: 1310 images
- strongest reported aggregate validation result:
  - Model_C
  - mAP50: 0.6178
  - Precision: 0.6500
  - Recall: 0.5911
  - F1 Score: 0.6192

Section-level claim anchors for version 1:

- Introduction
  - object detection is a foundational computer-vision task: literature-supported [1,2]
  - traffic scenes are difficult because of occlusion, clutter, distortion, and small objects: literature-supported [3-5]
  - the current study is a comparative YOLOv26 configuration study on Philippine traffic data: experiment-supported

- Results
  - Model_C is the strongest tested configuration: experiment-supported
  - Model_A has the highest precision but lower recall than Model_C: experiment-supported
  - Model_B is the weakest configuration on aggregate metrics: experiment-supported
  - Tricycle is the weakest class across all models: experiment-supported from per-class metrics
  - Jeepney is among the strongest classes: experiment-supported from per-class metrics

- Discussion
  - the current comparison is confounded because multiple hyperparameters changed together: experiment-supported from configuration table
  - traffic-related small or occluded objects remain challenging: literature-supported [4,5] and experiment-supported through weak class results
  - the balanced dataset still contains residual class imbalance: experiment-supported from notebook annotation counts

- Methods
  - environment: Google Colab, NVIDIA T4, Ultralytics 8.4.18: experiment-supported from notebook outputs
  - dataset size and split counts: experiment-supported
  - training configurations for Model_A, Model_B, and Model_C: experiment-supported
  - current reported outcomes are validation-based: experiment-supported

Do not make interpretive claims in the manuscript unless they can be tied back to a specific experiment artifact here.
