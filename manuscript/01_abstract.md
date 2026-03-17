# 01 Abstract

Reliable detection of road users in Philippine traffic is important for traffic monitoring and other safety-oriented computer vision applications. This study compared three YOLOv26 training configurations for detecting seven common road-user classes using a balanced dataset of 1,310 traffic-scene images. The models were trained and evaluated in Google Colab while varying optimizer, batch behavior, learning rate, and epoch count. Performance was assessed on the validation split using mAP50, precision, recall, and F1 score. Among the tested configurations, Model_C produced the strongest aggregate validation performance, achieving an mAP50 of 0.6178, precision of 0.6500, recall of 0.5911, and F1 score of 0.6192. Class-wise results remained uneven: Jeepney, SUV, and Truck were comparatively strong, whereas Tricycle was persistently difficult across all runs. The findings indicate that training configuration materially affects detection quality on this dataset, but the current comparison should be interpreted as a comparative validation study rather than a final deployment benchmark because multiple hyperparameters changed simultaneously and the held-out test split was not yet used for the final model selection.

Approximate word count:
- 158 words

Caution notes:
- the strongest reported result is currently based on validation metrics, not a final held-out test analysis
- the abstract avoids deployment claims beyond the present experiment evidence
