# Brain_Vessel_Segmentation_App

主app程序：data_process.mlapp/data_process.m （.mlapp可直接在matlab appdesigner内运行，也可以运行对应.m文件（matlab版本在2016a以下的话））

当前功能：skull-stripping\histogram matching\FCM\vessel enhance\MRF\image denoise\N4biasCorrection

【2023.5.20】

所有的分步骤处理的功能都可使用，分步骤的批量处理应该也可以使用;

合并步骤的单次处理和批量处理的代码已编写完毕但未调试过，可能存在bug;

主界面下的血管特征指标计算模块暂不可用，待更新；


skull-stripping:使用 https://github.com/MIC-DKFZ/HD-BET 的方法，需要在HD-BET-master文件夹下自主下载model文件到hd-bet_params文件夹（model网站：https://zenodo.org/record/2540695/files/0.model?download=1 ）；如需修改model文件路径，请在HD-BET-master/hd-bet/paths.py内修改

其他待更新
