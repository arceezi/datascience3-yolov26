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

Do not make interpretive claims in the manuscript unless they can be tied back to a specific experiment artifact here.
