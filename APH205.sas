/* APH205 Final Report */
/* Import the data */
proc import datafile="/home/u63515878/APH205 Final Report Database v2.xlsx" 
    out=covid
    dbms=xlsx 
    replace;
    getnames=yes;
run;

/* Descriptive Statistcs */
/* Calculate the BMI */
data covid;
    set covid;
    Height = Height_BL / 100;
    bmi = Weight_BL / Height**2;
run;

/* for perceived epidemic impacts */
proc means data=covid mean std min max;
    var COVID19_impact_dailylife COVID19_impact_studypractice COVID19_impact_familyincome
        COVID19_impact_familyhealth COVID19_impact_relationship COVID19_impact_score;
        
run;
/* for mental symptoms at the 4th follow-up */
proc means data=covid mean std min max;
    var PHQ9_score_F4 GAD7_score_F4 ISI_score_F4 bmi Age_BL;  
run;

/* Classification for PHQ-9 */
data covid;
    set covid;
    if PHQ9_score_F4 >= 0 and PHQ9_score_F4 <= 4 then PHQ9_Category = 'Normal';
    else if PHQ9_score_F4 >= 5 and PHQ9_score_F4 <= 9 then PHQ9_Category = 'Mild';
    else if PHQ9_score_F4 >= 10 and PHQ9_score_F4 <= 14 then PHQ9_Category = 'Moderate';
    else if PHQ9_score_F4 >= 15 and PHQ9_score_F4 <= 19 then PHQ9_Category = 'Moderate Severe';
    else if PHQ9_score_F4 >= 20 and PHQ9_score_F4 <= 27 then PHQ9_Category = 'Severe';
    else PHQ9_Category = 'Unknown';
run;

/* Frequency table */
proc freq data=covid;
    tables PHQ9_Category / out=work.phq9_freq;
run;

/* Pie chart */
proc gchart data=work.phq9_freq;
    pie PHQ9_Category / sumvar=Count
                        value=inside
                        percent=inside
                        slice=outside
                        coutline=black
                        noheading;
run;
quit;

/* Classification for GAD-7 */
data covid;
    set covid;
    if GAD7_score_F4 >= 0 and GAD7_score_F4 <= 4 then GAD7_Category = 'Normal';
    else if GAD7_score_F4 >= 5 and GAD7_score_F4 <= 9 then GAD7_Category = 'Mild';
    else if GAD7_score_F4 >= 10 and GAD7_score_F4 <= 14 then GAD7_Category = 'Moderate';
    else if GAD7_score_F4 >= 15 and GAD7_score_F4 <= 21 then GAD7_Category = 'Severe';
    else GAD7_Category = 'Unknown';
run;

/* Frequency table */
proc freq data=covid;
    tables GAD7_Category / out=work.gad7_freq;
run;

/* Pie chart */
proc gchart data=work.gad7_freq;
    pie GAD7_Category / sumvar=Count
                        value=inside
                        percent=inside
                        slice=outside
                        coutline=black
                        noheading;
run;
quit;

/* Classification for ISI */
data covid;
    set covid;
    if ISI_score_F4 >= 0 and ISI_score_F4 <= 7 then ISI_Category = 'Normal';
    else if ISI_score_F4 >= 8 and ISI_score_F4 <= 14 then ISI_Category = 'Subthreshold';
    else if ISI_score_F4 >= 15 and ISI_score_F4 <= 21 then ISI_Category = 'Moderate';
    else if ISI_score_F4 >= 22 and ISI_score_F4 <= 28 then ISI_Category = 'Severe';
    else ISI_Category = 'Unknown';
run;

/* Frequency table */
proc freq data=covid;
    tables ISI_Category / out=work.isi_freq;
run;

/* Pie chart */
proc gchart data=work.isi_freq;
    pie ISI_Category / sumvar=Count
                        value=inside
                        percent=inside
                        slice=outside
                        coutline=black
                        noheading;
run;
quit;

/* Correlation */
proc corr data=covid;
    var COVID19_impact_dailylife COVID19_impact_studypractice COVID19_impact_familyincome
        COVID19_impact_familyhealth COVID19_impact_relationship COVID19_impact_score 
        PHQ9_score_F4 GAD7_score_F4 ISI_score_F4 sex Age_BL bmi;
run;


/* Regression Analysis */
/* Multiple Regression Model for depression */
proc glm data=covid;
    class sex;
    model PHQ9_score_F4 = COVID19_impact_dailylife COVID19_impact_studypractice 
                          COVID19_impact_familyincome COVID19_impact_familyhealth 
                          COVID19_impact_relationship COVID19_impact_score sex Age_BL bmi / solution clparm;
run;

/* Multiple Regression Model for anxiety */
proc glm data=covid;
    class sex;
    model GAD7_score_F4 = COVID19_impact_dailylife COVID19_impact_studypractice 
                          COVID19_impact_familyincome COVID19_impact_familyhealth 
                          COVID19_impact_relationship COVID19_impact_score sex Age_BL bmi / solution clparm;
run;

/* Multiple Regression Model for insomnia */
proc glm data=covid;
    class sex;
    model ISI_score_F4 = COVID19_impact_dailylife COVID19_impact_studypractice 
                         COVID19_impact_familyincome COVID19_impact_familyhealth 
                         COVID19_impact_relationship COVID19_impact_score sex Age_BL bmi / solution clparm;
run;













