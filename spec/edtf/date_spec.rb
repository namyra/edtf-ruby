describe 'Date/DateTime' do

  describe 'class methods' do
    it 'responds to edtf' do
      Date.should respond_to(:edtf)
    end
  end
  
  describe 'instance methods' do
    [:uncertain?, :approximate?, :unspecified?, :uncertain, :approximate, :unspecified].each do |method|
      it "responds to #{method}" do
        Date.new.respond_to?(method).should == true
      end
    end
  end
  
  describe '#dup' do
    let(:date) { Date.edtf('2004-09?~') }
    
    it 'copies all date values' do
      date.dup.to_s == '2004-09-01'
    end
    
    it 'copies uncertainty' do
      date.dup.should be_uncertain
    end

    it 'copies approximate' do
      date.dup.should be_approximate
    end

    it 'copies precision' do
      date.dup.precision.should == :month
    end 
  end
  
  describe '#last_day_of_month' do
  
  	[[:March, 3, 31], [:August, 8, 31], [:September, 9, 30]].each do |x|
			describe "when the month is #{x[0]}" do
	
				let(:date) { Date.new(2008, x[1]) }
				
				it "should return #{x[2]}" do
					date.last_day_of_month.should == x[2]
				end
			end
		end
		
		describe 'when the month is February of a leap year' do
			let(:date) { Date.new(2008, 2) }
			
			it 'should return 29' do
				date.last_day_of_month.should == 29
			end			
		end
		
		describe 'when the month is February of a non-leap year' do
			let(:date) { Date.new(2009, 2) }
			
			it 'should return 28' do
				date.last_day_of_month.should == 28
			end			
		end
  end
  
  describe '#last_day_of_month?' do
  	it 'should return true for the 30th of November' do
  		Date.new(2008, 11, 30).should be_last_day_of_month
  	end
  	
  	it 'should return false for the 12th of May' do
  		Date.new(2008, 05, 12).should_not be_last_day_of_month
  	end
  end
  
  describe '#last_month_of_year' do
		it 'should return 12' do
			Date.new.last_month_of_year.should be 12
		end
  end
  
  describe '#last_month_of_year?' do
  	it 'should return true for December' do
  		Date.new(2008, 12).should be_last_month_of_year
  	end
  	
  	it 'should return false for August' do
  		Date.new(2008, 8).should_not be_last_month_of_year
  	end
  end

  describe '#uncertain?' do
    
    let(:date) { Date.new }
    
    it { Date.new.should_not be_uncertain }

    [:year, :month, :day].each do |part|
      it "should not be uncertain by default (#{part})" do
        Date.new.uncertain?(part).should == false
      end

      it "should be uncertain if set to uncertain (#{part})" do
        date.uncertain.send("#{part}=", true)
        date.uncertain?(part).should == true
      end

      ([:year, :month, :day] - [part]).each do |other|
        it "#{other} should not be uncertain if #{part} is uncertain" do
          date.uncertain.send("#{part}=", true)
          date.uncertain?(other).should == false
        end
      end
      
    end
    
  end
    
end