asm latchSR
import StandardLibrary


signature:

	monitored set_:Boolean
	monitored reset_:Boolean
	monitored clock_:Boolean
	controlled setAsync_: Boolean
	controlled resetAsync_: Boolean
	controlled q: Boolean
	controlled notq: Boolean
	controlled bistableStatus: Boolean


definitions:
	
	main rule r_Main=
		seq
			//if clock is false: opaque latchSR
			//if clock is true: trasparent latchSR
			par
				setAsync_:= (clock_ and set_)
				resetAsync_:= (clock_ and reset_)
			endpar
			
			switch(setAsync_,resetAsync_)
			
			    //set event
				case(true, false):
					seq
						notq:= not(setAsync_ or q)
						q:= not(resetAsync_ or notq)	
						bistableStatus:= q
					endseq
				
				//reset event	
				case(false, true):
					seq
						q:= not(resetAsync_ or notq)
						notq:= not(setAsync_ or q)	
						bistableStatus:=q
					endseq
				
				//hold event	
				case(false, false):
					skip
				
				//undefined event	
				case(true, true):
					choose $q in Boolean with true do
						seq
							q:=$q
							notq:=not $q
							bistableStatus:=q	
						endseq		
			endswitch
		endseq


default init s0:

	function q=false
	function notq=true
	function setAsync_=false
	function resetAsync_=false
	function bistableStatus=false
	
	

