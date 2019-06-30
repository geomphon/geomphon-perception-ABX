#create balanced model design based on comparisons
#make things the same length and add jitter

thing<-readr::read_csv(file="exp_designs/exp_design_HK_with_acoustic_distance.csv")
thing2<- thing[rep(seq_len(nrow(thing)), 2), ]

thing3<-thing2[1:144,c('Phone_NOTENG','Phone_ENG', 'Econ','Loc','Glob','Acoustic distance')]

for (i in 105:144){
  thing3$`Acoustic distance`[i]<- jitter(thing3$`Acoustic distance`[i])
}

write_csv(thing3,path = "exp_designs/exp_design_hk_144.csv")
write_csv()



that<-readr::read_csv(file="exp_designs/exp_design_Hindi_with_acoustic_distance.csv")
that2<- that[rep(seq_len(nrow(that)), 3), ]
that3<-that2[1:144,c('Phone_NOTENG','Phone_ENG', 'Econ','Loc','Glob','Acoustic distance')]

for (i in 60:144){
  that3$`Acoustic distance`[i]<- jitter(that3$`Acoustic distance`[i])
}

write_csv(that3,path = "exp_designs/exp_design_hindi_144.csv")

