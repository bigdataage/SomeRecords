mkdir		ce11			
mkdir		mm10			
					
hisat2-build	-p 4    Shortcuts/ce11.fa	        ce11/ce11	        >>ce11.buildIndex.runLog	2>&1
hisat2-build	-p 4    Shortcuts/mm10.fa		mm10/mm10		>>mm10.buildIndex.runLog	2>&1
