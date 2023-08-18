/**
 *
 * @author : 409410121, 409410120
 * @latest changed : 2022/6/3 4:25
 */
module JAM(
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );


integer i;

reg [5:0]state;
reg [2:0]num[0:7];
integer t;
integer n;
integer j;
integer k;
integer a;
integer min;
integer b;
integer r;
integer w;
integer o;
reg [10:0]cost;
reg [9:0]ca[7:0];


initial begin
    $dumpfile("JAM.vcd");
    $dumpvars(0, testfixture);
    for(i = 0; i < 8; i = i+1)
	 begin
        $dumpvars(1, num[i]);
        num[i]<=i;
        ca[i]<=0;
	 end
end

always @(posedge CLK or posedge RST) 
begin
    if(RST)
    begin
        state <= 2;
        i<=7;
        j<=7;
        MatchCount <= 0;
        MinCost <= 0;
        t<=8;
        k<=7;
        a<=0;
        b<=0;
        w<=0;
        o<=0;
        r<=0;
        cost<=0;
        min <= 1024;
    end
    else if( state == 1 )
    begin
    	if( j == 0 ) Valid<=1;
    	else if( num[j-1] < num[j] || r==1 )
    	begin
    		r<=1;
    		o<=j-2;
			if( i < j )
			begin
				if( a==0 & b ==0 )
				begin
					a<=j;
					b<=7;
					num[j-1]<=num[k];
					num[k]<=num[j-1];
				end
				else if( a >= b ) state<=2;
				else if( a < b )
				begin
					num[a]<=num[b];
					num[b]<=num[a]; 
					a<=a+1;
					b<=b-1;
				end
			end
    		else if( num[i] > num[j-1] && num[i] < t)
    		begin
    			t <= num[i];
    			k<=i;
    		end
    		else i<=i-1;
    	end
    	else j<=j-1;
    end
    else if( state == 2 )
    begin
		if( w == 8 )
		begin 
			if( cost == min ) 
			begin
				MatchCount <= MatchCount+1;
			end
			else if( cost < min )
			begin
				MinCost <=cost; 
				min<=cost;
				MatchCount<=1;
			end
			state<=1;
			j<=7;
			i<=7;
			a<=0;
			b<=0;
			t<=8;
			w<=0;
			o<=0;
			r<=0;
			cost<=0;
		end
		else
		begin
			if(!cost && w < o)
			begin
				W<=o;
				w<=o;
				J<=num[o];
				cost<=ca[o];
			end
			else
			begin
				W<=w;
				J<=num[w];
				ca[w] <= cost;
			end
			if( ca[o] >= min )
			begin
					state<=1;
					j<=7;
					i<=7;
					a<=0;
					b<=0;
					t<=8;
					w<=0;
					r<=0;
					cost<=0;
			end
			else if( cost >= min )
			begin
					state<=1;
					j<=7;
					i<=7;
					a<=0;
					b<=0;
					t<=8;
					w<=0;
					r<=0;
					cost<=0;
			end
			else state<=3;
		end
    end
    else if( state == 3 )
    begin
		cost<=cost+Cost;
		w<=w+1;
		state<=2;
    end
    	
end

endmodule
