-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity tlight is
port (NS,EW : out std_logic_vector(1 downto 0);
SEN,CK: in std_logic; SW: inout std_logic:='0');
end tlight;

architecture behavior of tlight is

	type statetype is(NSred,NSgreen,NSyellow,EWyellow,EWgreen,EWred);
	signal NSstate,EWnextstate,EWstate,NSnextstate: statetype;
    signal select_10_50: std_logic:='1';
   begin
        
    
    p1: process(CK) 
    variable count : integer:=0;
    begin
    	if(rising_edge(CK)) then
        	count := count + 1;
        	if (count=10 and select_10_50='1')then--change at ck=10ns
            	SW<='1';
                select_10_50<='0';
                count := 0;
            elsif (count=50)then
            	SW<='0';
                select_10_50<='1';
                count := 0;
            end if;
        end if;
    	
    end process;
    
    p2: process(SW,SEN,CK) begin--
    	if(SEN='0')then
        	NSstate<=NSgreen;
            EWstate<=EWred;
       elsif(SEN='1')then
        --NS
        if (NSstate=NSgreen)then
    		if(falling_edge(SW))then
            	NSstate<= NSnextstate;
    		end if;
            
            
        else  
        	if(rising_edge(SW))then
            	NSstate<= NSnextstate;
    		end if;
        end if;
        --EW
        if (EWstate=EWgreen)then
    		if(falling_edge(SW))then
            	EWstate<= EWnextstate;
    		end if;
       else  
        	if(rising_edge(SW))then
            	EWstate<= EWnextstate;
    		end if;
        end if;
  
       end if;
        
    end process;
    
   p3: process(SW,SEN,CK) begin--
   --NS
    	if(SEN='0')then
        	NSnextstate<=NSgreen;
        elsif(SEN='1')then
        	
            if(NSstate=NSgreen )then
            	NSnextstate<=NSyellow;
            end if;
        
        	if(NSstate=NSyellow)then
        		NSnextstate<=NSred;
        	end if;
        	if(NSstate=NSred and EWstate=EWyellow)then
        		NSnextstate<=NSgreen;
        	end if;
        	--if(NSstate=NSred)then
        		--NSnextstate<=NSred;	
        	--end if;
        end if;
        --EW
        if(SEN='0')then
        	EWnextstate<=EWred;
        elsif(SEN='1')then
        	if(EWstate=EWgreen)then
        		EWnextstate<=EWyellow;
        	end if;
        	if(EWstate=EWyellow)then
        		EWnextstate<=EWred;
        	end if;
        	if(EWstate=EWred and NSstate=NSyellow)then
        		EWnextstate<=EWgreen;
        	end if;
        	--if(EWstate=EWred)then
        		--EWnextstate<=EWred;	
        	--end if;
        end if;
    end process;
--00 Green
--01 Yellow
--10 Red
	NS<= "00" when NSstate=NSgreen else
    	 "01" when NSstate=NSyellow else
         "10" when NSstate= NSred;
    EW<= "00" when EWstate=EWgreen else
    	 "01" when EWstate=EWyellow else
         "10" when EWstate= EWred ;   
    
    
end behavior;