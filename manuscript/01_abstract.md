# 01 Abstract

Reliable detection of road users in Philippine traffic scenes can support traffic monitoring and other safety-related computer vision tasks. This study evaluated YOLOv26 for detecting seven common road-user classes in Philippine traffic images using a balanced dataset of 1,310 images. Three training configurations were compared in Google Colab by varying optimizer, batch size, learning rate, and epoch count. Model performance was assessed using mAP50, precision, recall, and F1 score. Among the tested configurations, Model_C achieved the strongest validation performance with an mAP50 of 0.6178, precision of 0.6500, recall of 0.5911, and F1 score of 0.6192, outperforming Model_A and Model_B on aggregate metrics. The results indicate that training configuration choice materially influences detection quality for this dataset and that gains are not uniform across classes. These findings provide an initial benchmark for road-user detection in Philippine traffic images and support further work on tighter hyperparameter control, class-specific error analysis, and broader validation before real-world deployment.

Approximate word count:
- 143 words

Caution notes:
- the strongest reported result is currently based on validation metrics, not a final held-out test analysis
- the abstract avoids deployment claims beyond the present experiment evidence
