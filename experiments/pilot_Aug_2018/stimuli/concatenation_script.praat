#Concatenation script
#

#import csv
nameList= Read Table from comma-separated file... AX_Plat_Dummy.csv

n = Get number of rows

for i to n
   select nameList
   nameone$ = Get value... i File1
   Read from file... Soundfiles/'nameone$'
     Rename... file1_'i'

					select nameList
					silence$ = Get value... i File5-Silence
        				Read from file... Soundfiles/'silence$'
        				Rename... silence

	select nameList
	nametwo$ = Get value... i File2
        Read from file... Soundfiles/'nametwo$'
        Rename... file2_'i'
		
					select nameList
					silence$ = Get value... i File5-Silence
        				Read from file... Soundfiles/'silence$'
        				Rename... silence2
			

			select nameList
			namethree$ = Get value... i File3
       	 		Read from file... Soundfiles/'namethree$'
        		Rename... file3_'i'

					select nameList
					silence$ = Get value... i File5-Silence
        				Read from file... Soundfiles/'silence$'
        				Rename... silence3

				select nameList
				namefour$ = Get value... i File4
       				Read from file... Soundfiles/'namefour$'
        			Rename... file4_'i'


						select nameList
						tone$ = Get value... i File6-Tone
        					Read from file... Soundfiles/'tone$'
        					Rename... tone_'i'

								select nameList
								testFile$ = Get value... i File7-Test
        							Read from file... Soundfiles/'testFile$'
        							Rename... test_'i'


		
		#concatenate
		select Sound file1_'i'
		plus Sound silence
		plus Sound file2_'i'
		plus Sound silence2
		plus Sound file3_'i'
		plus Sound silence3
		plus Sound file4_'i'
		plus Sound tone_'i'
		plus Sound test_'i'

		Concatenate recoverably


       				 ##### get correct answer from text file
					select nameList
					answer$ = Get value... i Answer
	
		######## save the file
			select Sound chain
			Write to WAV file... Concatenated/tripletid_'i'_'answer$'.wav
endfor








