asm bistabileAsincronoSR
import StandardLibrary


signature:

	monitored set_: Boolean
	monitored reset_: Boolean
	controlled q: Boolean
	controlled notq: Boolean
	controlled bistableStatus: Boolean


definitions:
	
	main rule r_Main=
		switch(set_,reset_)
		
		    //set event
			case(true, false):
				seq
					notq:= not(set_ or q)
					q:= not(reset_ or notq)	
					bistableStatus:= q
				endseq
			
			//reset event	
			case(false, true):
				seq
					q:= not(reset_ or notq)
					notq:= not(set_ or q)	
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


default init s0:

	function q=false
	function notq=true
	function bistableStatus=false
	
	

