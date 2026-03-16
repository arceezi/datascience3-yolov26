# 05 Interpretation Notes

This file is for the "why" behind the results.

Current experiment observations from the notebook:
- Model_C currently has the best aggregate performance among the three tested runs
- Model_B performs worst overall
- Tricycle appears to be the weakest class across the reported per-class metrics
- Jeepney appears comparatively strong

Questions to answer in the report:
- did the longer training schedule improve learning or just change optimization behavior?
- did the smallest learning rate converge more effectively for this dataset?
- how much of the performance gap is due to optimizer choice versus batch size, epoch count, or learning rate?
- which classes likely remain difficult because of visual similarity, scale, occlusion, or dataset limitations?

Use this file to store interpretation ideas before they are promoted into the manuscript.
