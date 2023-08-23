%% Obtain static data to calculate rotation matrix

Stat_file=importdata(static_file);

MT1_stat_all=Stat_file.data(:,2:4);
MT1_stat=nanmean(MT1_stat_all);

MT5_stat_all=Stat_file.data(:,5:7);
MT5_stat=nanmean(MT5_stat_all);

CALC_stat_all=Stat_file.data(:,8:10);
CALC_stat=nanmean(CALC_stat_all);

MedMal_stat_all=Stat_file.data(:,11:13);
MedMal_stat=nanmean(MedMal_stat_all);

LatMal_stat_all=Stat_file.data(:,14:16);
LatMal_stat=nanmean(LatMal_stat_all);

MedKnee_stat_all=Stat_file.data(:,17:19);
MedKnee_stat=nanmean(MedKnee_stat_all);

LatKnee_stat_all=Stat_file.data(:,20:22);
LatKnee_stat=nanmean(LatKnee_stat_all);

HIP_stat_all=Stat_file.data(:,23:25);
HIP_stat=nanmean(HIP_stat_all);

MidKnee_stat_all=Stat_file.data(:,26:28);
MidKnee_stat=nanmean(MidKnee_stat_all);

MidAnkle_stat_all=Stat_file.data(:,29:31);
MidAnkle_stat=nanmean(MidAnkle_stat_all);

MidMT_stat=(MT1_stat + MT5_stat)/2;



