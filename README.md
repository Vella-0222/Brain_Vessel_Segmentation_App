# Brain_Vessel_Segmentation_App

主app程序：data_process.mlapp/data_process.m （.mlapp可直接在matlab appdesigner内运行，也可以运行对应.m文件（matlab版本在2016a以下的话））

当前功能：skull-stripping\histogram matching\FCM\vessel enhance\MRF\image denoise

其中MRF的批量处理功能有待修改，暂时不可用

N4偏置场校正程序调试存在问题，暂未上传

skull-stripping:使用 https://github.com/MIC-DKFZ/HD-BET 的方法，需要在HD-BET-master文件夹下自主下载model文件到hd-bet_params文件夹（model网站：https://zenodo.org/record/2540695/files/0.model?download=1 ）；如需修改model文件路径，请在HD-BET-master/hd-bet/paths.py内修改

其他待更新
