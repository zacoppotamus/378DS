########################################
##  Import tables into R from Oracle  ##
########################################

#Import Smaller tables
HCAHPSMeasure = dbGetQuery(con, "Select * From Measures")
InpatientServices <- dbGetQuery(con, "Select * from InpatientServices")
Providers = dbGetQuery(con, "Select * from Providers")
OutpatientServices <- dbGetQuery(con, "Select * from OutpatientServices")

#Inport Outpatient Visits Table
OutpatientVisits <- dbGetQuery(con, "select * from Outpatient WHERE ID BETWEEN 0 and 30000")
OutpatientVisits = rbind(OutpatientVisits, dbGetQuery(con, "select * from Outpatient WHERE ID BETWEEN 30001 and 60000"))
OutpatientVisits = rbind(OutpatientVisits, dbGetQuery(con, "select * from Outpatient WHERE ID BETWEEN 60001 and 90000"))
OutpatientVisits = rbind(OutpatientVisits, dbGetQuery(con, "select * from Outpatient WHERE ID BETWEEN 90001 and 100000"))

#Import Inpatient Visits Table
InpatientVisits <- dbGetQuery(con, "select * from Inpatient WHERE ID BETWEEN 0 and 30000")
InpatientVisits = rbind(InpatientVisits, dbGetQuery(con, "select * from Inpatient WHERE ID BETWEEN 30001 and 60000"))
InpatientVisits = rbind(InpatientVisits, dbGetQuery(con, "select * from Inpatient WHERE ID BETWEEN 60001 and 90000"))
InpatientVisits = rbind(InpatientVisits, dbGetQuery(con, "select * from Inpatient WHERE ID BETWEEN 90001 and 100000"))
InpatientVisits = rbind(InpatientVisits, dbGetQuery(con, "select * from Inpatient WHERE ID BETWEEN 100001 and 130000"))
InpatientVisits = rbind(InpatientVisits, dbGetQuery(con, "select * from Inpatient WHERE ID BETWEEN 130001 and 160000"))

###################################
## Run queries to get dataframes ##
###################################

outpatientCostByCity = dbGetQuery(con, 
                                  "SELECT Providers.City as City, AVG(OutPatient.AverageSubmittedCharges) as AvgBilledCost 
                                  FROM OutPatient
                                  INNER JOIN Providers 
                                  ON Providers.ID = OutPatient.ProviderID 
                                  GROUP BY Providers.City")

outpatientCostByState = dbGetQuery(con, 
                                   "SELECT Providers.State as State, AVG(OutPatient.AverageSubmittedCharges) as AvgBilledCost 
                                   FROM Outpatient 
                                   INNER JOIN Providers 
                                   ON Providers.ID = Outpatient.ProviderID 
                                   GROUP BY Providers.State")

outpatientCostByHospital = dbGetQuery(con, "
                                      SELECT Providers.Name as Hospital, AVG(OutPatient.AverageSubmittedCharges) as AvgBilledCost 
                                      FROM OutPatient 
                                      INNER JOIN Providers 
                                      ON Providers.ID = OutPatient.ProviderID 
                                      GROUP BY Providers.Name")

outpatientCostByCity = dbGetQuery(con, 
                                  "SELECT Providers.City as City, AVG(OutPatient.AverageSubmittedCharges) as AvgBilledCost 
                                  FROM OutPatient 
                                  INNER JOIN Providers 
                                  ON Providers.ID = OutPatient.ProviderID 
                                  GROUP BY Providers.City")

outpatientCostByState = dbGetQuery(con, 
                                   "SELECT Providers.State as State, AVG(OutPatient.AverageSubmittedCharges) as AvgBilledCost 
                                   FROM OutPatient 
                                   INNER JOIN Providers 
                                   ON Providers.ID = OutPatient.ProviderID 
                                   GROUP BY Providers.State")

outpatientCostByHospital = dbGetQuery(con, 
                                      "SELECT Providers.Name as Hospital, AVG(OutPatient.AverageSubmittedCharges) as AvgBilledCost 
                                      FROM OutPatient 
                                      INNER JOIN Providers 
                                      ON Providers.ID = OutPatient.ProviderID 
                                      GROUP BY Providers.Name")

InpatientCostByCity = dbGetQuery(con, 
                                 "SELECT Providers.City as City, AVG(InPatient.CoveredCharges) as AvgBilledCost 
                                 FROM InPatient 
                                 INNER JOIN Providers 
                                 ON Providers.ID = InPatient.ProviderID 
                                 GROUP BY Providers.City")

InpatientCostByState = dbGetQuery(con, 
                                  "SELECT Providers.State as State, AVG(Inpatient.CoveredCharges) as AvgBilledCost 
                                  FROM Inpatient 
                                  INNER JOIN Providers 
                                  ON Providers.ID = Inpatient.ProviderID 
                                  GROUP BY Providers.State")

InpatientCostByHospital = dbGetQuery(con, "
                                     SELECT Providers.Name as Hospital, AVG(InPatient.CoveredCharges) as AvgBilledCost 
                                     FROM InPatient 
                                     INNER JOIN Providers 
                                     ON Providers.ID = InPatient.ProviderID 
                                     GROUP BY Providers.Name")

PatientsRated9or10 = dbGetQuery(con, "
                                Select Providers.Name, Reviews.AnswerPercent FROM Providers
                                INNER JOIN Reviews 
                                ON Providers.ID = Reviews.ProviderID
                                WHERE reviews.SurveyID = 'H_HSP_RATING_9_10'")
PatientsRated9or10$ANSWERPERCENT <- as.numeric(PatientsRated9or10$ANSWERPERCENT)

CostVSRating = dbGetQuery(con, "
                          Select Reviews.Answerpercent AS Rating, Reviews.SurveyID AS Question, 
                          Outpatient.AverageSubmittedCharges AS Cost, Outpatient.AVERAGETOTALPAYMENTS AS InsuredCost,
                          Providers.Name as Name, Providers.State, Providers.HOSPITALREFERRALREGION AS Region, OutpatientServices.Description as Procedure
                          From Reviews
                          INNER JOIN Outpatient
                          ON Reviews.ProviderID = Outpatient.ProviderID 
                          INNER JOIN OutpatientServices
                          ON OutpatientServices.ID = Outpatient.APCID
                          INNER JOIN Providers
                          On Outpatient.ProviderID = Providers.ID
                          ")
######################
##      Set-up      ##
######################

#############################
##  Get Data subsets in R  ##
#############################

Rated9or10 = subset(CostVSRating, QUESTION == 'H_HSP_RATING_9_10')
Rated7or8 = subset(CostVSRating, QUESTION == 'H_HSP_RATING_7_8')
Rated0to6 = subset(CostVSRating, QUESTION == 'H_HSP_RATING_0_6')
DefinitelyRecommend = subset(CostVSRating, QUESTION == 'H_RECMND_DY')
ProbablyRecommend = subset(CostVSRating, QUESTION == 'H_RECMND_PY')
NotRecommend = subset(CostVSRating, QUESTION == 'H_RECMND_DN')
TexasQuery = subset(CostVSRating, STATE == 'TX')
AustinQuery = subset(TexasQuery, REGION == 'TX - Austin')

AverageCostBy910Rating <- aggregate(cbind(COST, INSUREDCOST) ~ REGION, Rated9or10, mean)
CheaperOutpatient = subset(AverageCostBy910Rating, COST < 2000)

InpatientVisits$TOTALPAYMENTS <- as.numeric(InpatientVisits$TOTALPAYMENTS)

p <- subset(OutpatientVisits, APCID == 12)
p <- mean(p$AVERAGESUBMITTEDCHARGES)
TexasCostByProcedure <- aggregate(INSUREDCOST ~ REGION, TexasQuery, mean)