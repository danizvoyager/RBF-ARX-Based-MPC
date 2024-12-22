load m_input
load m_output
rcpi = price2ret(DataTable.CPIAUCSL);
unrate = DataTable.UNRATE(2:end);
idx = all(~ismissing([rcpi unrate]),2);
Data = array2timetable([rcpi(idx) unrate(idx)],...
    'RowTimes',DataTable.Time(idx),'VariableNames',{'rcpi','unrate'});
Mdl = varm(4,3);
EstMdl = estimate(Mdl,Data.Variables);