#Code to split ascii population data into a csv file

#Explanation
#Given 1969AL01001991910000000159 as a column, the following:
#    Year - Col 1-4 (1969)
#    State Postal - Col 5-6 (AL)
#    State FIPS - Col 7-8 (01)
#    County FIPS - Col 9-11 (001)
#    Registry - Col 12-13 (99)
#    Race - Col 14 (1)
#    Origin - Col 15 (9)
#    Sex - Col 16 (1)
#    Age - Col 17-18 (00)
#    Population - Col 19-26 (00000159)


import csv

#create new file
#and write headers
new_file = open("pop_data.csv", "w")
new_file.write("Year,State_P,State_FIPS,County_FIPS,FIPS,Registry,Race,Origin,Sex,Age,Population\n")

#county_names = open("national_county.txt", "r")


#read text file and split into above categories.
#then write into csv file
i = 0
with open("adjusted_pop_USA.txt") as fp:
	for line in fp:
		
		i = i + 1
		year = line[:4]
		postal = line[4:6]
		FIPS_St = line[6:8]
		FIPS_Co = line[8:11]
		FIPS = FIPS_St + FIPS_Co
		registry = line[11:13]
		race = line[13]
		origin = line[14]
		sex = line[15]
		age = line[16:18]
		pop = line[18:]
		comma = ","

		string_to_write = year + comma + postal + comma + FIPS_St + comma + FIPS_Co + comma + FIPS + comma + registry \
											+ comma + race + comma + origin + comma + sex + comma + age + comma + pop

		new_file.write(string_to_write)
		if i%100 == 0:
			print str(i) + " lines written" 



