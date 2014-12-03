######################
##      Plots       ##
######################
p3 <- hist(InpatientVisits$TOTALPAYMENTS, main = "Inpatient Procedure Cost", xlab = "Average Ammount Billed Per Procedure", ylab = "# of Hospitals", xlim = c(0, 60000))
p4 <- hist(OutpatientVisits$AVERAGESUBMITTEDCHARGES, main = "Outpatient Procedure Cost", xlab = "Average Amount Billed Per Procedure", xlim = c(0, 12000))
p5 <- hist(PatientsRated9or10$ANSWERPERCENT, main = "Patient Satisfaction \nRatings", xlab = "Percent of Patients Who Rated \n Their Hospital 9+ out of 10", ylab = "# of Hospitals", xlim = c(25, 100))
p1 <- ggplot(InpatientCostByState, aes(x = STATE, y = AVGBILLEDCOST)) + geom_point() + coord_flip()
p1
p2 <- ggplot(outpatientCostByState, aes(x = STATE, y = AVGBILLEDCOST)) + geom_point() + coord_flip()
p2
p7 <- ggplot(Rated9or10, aes(x = RATING, y = COST)) + geom_point() + facet_wrap(~PROCEDURE)
p7
p8 <- ggplot(Rated9or10, aes(x = RATING, y = COST)) + geom_point() + facet_wrap(~STATE)
p8
p10 <- ggplot(TexasCostByProcedure, aes(x = PROCEDURE, y = UNINSUREDCOST)) + geom_point() + coord_flip()
p10
p11 <- ggplot(TexasQuery, aes(x = RATING, y = COST)) + geom_point() + facet_wrap(~PROCEDURE)
p11
p12 <- ggplot(AustinQuery, aes(x = RATING, y = COST)) + geom_point() + facet_wrap(~PROCEDURE)
p12

