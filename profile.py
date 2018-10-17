import pandas as pd
import pandas_profiling

df = pd.read_csv("VNP14IMGTDL_NRT_Global_24h.csv", parse_dates=True, encoding='UTF-8')
profile = pandas_profiling.ProfileReport(df)
profile.to_file(outputfile="report.html")
