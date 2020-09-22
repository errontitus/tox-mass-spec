# Example use of AB SCIEX\MS Data Converter.
# I do not currently use this, as I have had trouble working with the files it generates.
# Currently using proteowizard instead.

cd "C:\Program Files\AB SCIEX\MS Data Converter"

# When multiple results are in a single wiff file, the output name is used as a stem.
AB_SCIEX_MS_Converter WIFF "D:\Analyst Data\Projects\QTOF_CDS\Data\QTOF_CDS_2020_08_18.wiff" -profile MZML "C:\Users\How\Documents\Erron\QTOF_CDS_2020_08_18.mzXML"

Pause