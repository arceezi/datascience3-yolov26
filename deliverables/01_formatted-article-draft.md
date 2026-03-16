# Formatted Article Draft

This file is the main polished review artifact for the scientific report.

Use this document to see the current article in full reading order and to judge whether the product already looks submission-ready in structure and presentation.

Important workflow note:
- write and revise source content in `manuscript/`
- reflect polished combined content here in `deliverables/`
- export this draft later to `.docx` or `.pdf` into `deliverables/exports/`

---

# Detection and Classification of Common Road Users in Philippine Traffic Using YOLOv26

Adviser: John Paul Q. Tomas

## Abstract

Reliable detection of road users in Philippine traffic scenes can support traffic monitoring and other safety-related computer vision tasks. This study evaluated YOLOv26 for detecting seven common road-user classes in Philippine traffic images using a balanced dataset of 1,310 images. Three training configurations were compared in Google Colab by varying optimizer, batch size, learning rate, and epoch count. Model performance was assessed using mAP50, precision, recall, and F1 score. Among the tested configurations, Model_C achieved the strongest validation performance with an mAP50 of 0.6178, precision of 0.6500, recall of 0.5911, and F1 score of 0.6192, outperforming Model_A and Model_B on aggregate metrics. The results indicate that training configuration choice materially influences detection quality for this dataset and that gains are not uniform across classes. These findings provide an initial benchmark for road-user detection in Philippine traffic images and support further work on tighter hyperparameter control, class-specific error analysis, and broader validation before real-world deployment.

## Introduction

[Sync from `manuscript/02_introduction.md`]

## Results

[Sync from `manuscript/03_results.md`]

### Table 1. Comparative Performance of YOLOv26 Model Configurations

[Insert the polished comparative metrics table here]

Caption note:
- report mAP50, Precision, Recall, and F1 for Model_A, Model_B, and Model_C

### Figure 1. Confusion Matrix

[Insert the selected confusion matrix figure here]

Caption note:
- explain what the confusion matrix suggests about class confusion or error patterns

### Figure 2. Training Dynamics

[Insert the selected training loss or mAP curves here]

Caption note:
- explain convergence behavior and whether training appears stable, slow, or potentially overfit

## Discussion

[Sync from `manuscript/04_discussion.md`]

## Methods

[Sync from `manuscript/05_methods.md`]

## References

[Sync from `manuscript/06_references.md`]

---

Formatting review notes:
- keep section order exactly as shown above
- use visible headings and clear caption labels
- preserve a clean journal-style flow
