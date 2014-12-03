#load libraries needed
library(shiny)
library(shinyapps)
library(rJava)
library(DBI)
library(RJDBC)
library(ggplot2)

#connect to Oracle database
options(java.parameters="-Xmx2g")
jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="~/ojdbc7.jar")
con <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521/pdborcl", "ds_medicare", "orcl")

