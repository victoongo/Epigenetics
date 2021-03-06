# bhv.vars <- c("CEBQ_SRSE", "CEBQ_FR", "CEBQ_EF", "CEBQ_EOE")
pData$BASC_HY1 <- log(10 + pData$BASC_HY)
pData$BRF_SF1 <- log(pData$BRF_SF - 5)
pData$BRF_WM1 <- log(pData$BRF_WM - 12)
pData$BRF_IN1 <- log(pData$BRF_IN - 5)
pData$BRF_EC1 <- log(pData$BRF_EC - 5)
pData$BRF_PO1 <- log(pData$BRF_PO - 5)

bhv.vars <- c("BASC_HY1", "BRF_SF1", "BRF_WM1", "BRF_IN1", "BRF_EC1", "BRF_PO1")

pca_input <- subset(pData, select=bhv.vars)

pca <- prcomp(~BASC_HY1+BRF_SF1+BRF_WM1+BRF_IN1+BRF_EC1+BRF_PO1, data=pData, scale=T)
# pca <- prcomp(na.omit(pca_input), scale=T)
pca_output <- predict(pca, newdata=pca_input)
pData <- cbind(pData, pca_output)
# summary(pca)
# plot(pca)

bhv.vars <- c("PC1", "PC2", "PC3")

#create categorical variables for mother's ADHD, education, parity, and pre-pregnancy BMI
pData$asrs_ADHD_2cat <- factor(pData$asrs_ADHD, labels = 0:1, levels = 0:1)
pData$education_3cat<- factor(pData$education_3cat, labels = 1:3, levels = 1:3)
pData$parity_3cat <- factor(pData$parity_3cat, labels = 0:2, levels = 0:2)
pData$prePregBMIthreeLev <- factor(cut(pData$BMI_LMP_kgm2, c(0, 30, 35, 100), right=F), exclude=NA, ordered=TRUE)
# pData$prePregBMIthreeLev <- rep(NA, nrow(pData))
# pData$prePregBMIthreeLev[(!is.na(pData$BMI_LMP_kgm2)) & (pData$BMI_LMP_kgm2 < 30)] <- 0
# pData$prePregBMIthreeLev[(!is.na(pData$BMI_LMP_kgm2)) & (pData$BMI_LMP_kgm2 >= 30) & (pData$BMI_LMP_kgm2 < 35)] <- 1
# pData$prePregBMIthreeLev[(!is.na(pData$BMI_LMP_kgm2)) & (pData$BMI_LMP_kgm2>=35)] <- 2
# pData$prePregBMIthreeLev <-factor(pData$prePregBMIthreeLev, levels = 0:2, labels = c("Lt30", "30toLt35", "Ge35"))

cntrl <- c("age_mo_SR_Surv", "sex", "birthwt_kg",
           "GestAge_weeks", "education_3cat", "race_final_n", "parity_3cat",
           "mom_age_delv", "BMI_LMP_kgm2", 'maternal_smoking2')

yx <- c(bhv.vars, cntrl)
names(pData)[duplicated(names(pData))] <- 'nestid_dup' # has a dup name, need to check earlier code.
reg.vars <- dplyr::select(pData, one_of(yx))

# reg.vars <- data.frame(pData$CEBQ_SRSE, pData$CEBQ_FR, pData$CEBQ_EF, pData$CEBQ_EOE,
#                        pData$age_mo_SR_Surv, pData$sex, pData$birthwt_kg,
#                        pData$GestAge_weeks, pData$education_3cat, pData$race_final_n, pData$parity_3cat,
#                        pData$mom_age_delv, pData$prePregBMIthreeLev, pData$asrs_ADHD_2cat)

colnames(reg.vars) <- yx

# cntrl <- c("~reg.vars$age_mo_SR_Surv", "sex", "birthwt_kg",
#            "GestAge_weeks", "education_3cat", "race_final_n", "parity_3cat",
#            "mom_age_delv", "prePregBMIthreeLev", "asrs_ADHD_2cat")