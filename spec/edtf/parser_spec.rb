module EDTF
  describe Parser do
    describe '#parse' do
      
      it 'parses simple dates "2001-02-03"' do
        Parser.new.parse('2001-02-03').to_s.should == '2001-02-03'
      end
      
      it 'parses negative years' do
        Parser.new.parse('-2323').to_s.should == '-2323-01-01'
      end
      
      it 'parses year zero' do
        Parser.new.parse('0000').to_s.should == '0000-01-01'
      end
      
      it 'parses date/time with time zones' do
        Parser.new.parse('2011-08-15T11:19:00+01:00').to_s.should == '2011-08-15T11:19:00+01:00'
      end
      
      it 'parses simple intervals like "2007/2008"' do
        Parser.new.parse('2007/2008').should include(Date.new(2007,12,24))
        Parser.new.parse('2007/2008').should_not include(Date.new(2008,1,2))
      end
   
      it 'parses uncertain dates' do
        Parser.new.parse('1984?').should be_uncertain        
        Parser.new.parse('1984').should be_certain
      end

      it 'parses approximate dates' do
        Parser.new.parse('1984-01~').should be_approximate
        Parser.new.parse('1984-01').should be_precise
      end

      it 'parses uncertain approximate dates' do
        Parser.new.parse('1984?~').should be_uncertain
        Parser.new.parse('1984?~').should be_approximate
      end

      it 'parses unspecified dates' do
        Parser.new.parse('199u').should be_unspecified
        Parser.new.parse('1999-uu-uu').should be_unspecified
      end
      
      it 'parses open intervals' do
        Parser.new.parse('2004-01-01/open').should be_open
      end

      it 'parses unknown intervals' do
        Parser.new.parse('2004-01-01/unknown').should be_unknown_end
        Parser.new.parse('unknown/2004-01-01').should be_unknown_start
      end
      
      it 'parses intervals with uncertain or approximate dates' do
        Parser.new.parse('1984-06-02?/2004-08-08~').from.should be_uncertain
        Parser.new.parse('1984-06-02?/2004-08-08~').to.should be_approximate
      end
      
      it 'should parse positive long years' do
        Parser.new.parse('y170000002').year.should == 170000002
      end
      
      it 'should parse negative long years' do
        Parser.new.parse('y-170000002').year.should == -170000002
      end
      
      it 'should parse season codes' do
        Parser.new.parse('2003-23').should be_autumn
      end

      it 'should parse calendar names' do
        Parser.new.parse('2001-02-03^xyz').calendar.should == 'xyz'
      end
      
      it 'should parse season qualifiers' do
        d = Parser.new.parse('2003-23^european')
        d.should be_autumn
        d.should be_qualified
        d.qualifier.should == 'european'
      end
      
      it 'should parse positive scientific long years' do
        Parser.new.parse('y17e7').year.should == 170000000
      end
      
      it 'should parse negative scientific long years' do
        Parser.new.parse('y-17e7').year.should == -170000000        
      end
      
      it 'parses masked precision date strings (decades)' do
        d = Parser.new.parse('198x')
        d.should include(Date.new(1983,3,12))
        d.should_not include(Date.new(1990,1,1))
      end

      it 'parses masked precision date strings (centuries)' do
        d = Parser.new.parse('18xx')
        d.should include(Date.new(1848,1,14))
        d.should_not include(Date.new(1799,12,31))
      end
      
      it 'parses multiple dates (years)' do
        d = Parser.new.parse('{1667,1668, 1670..1672}')
        d.map(&:year).should == [1667,1668,1670,1671,1672]
      end
      
      it 'parses multiple dates (mixed years and months)' do
        d = Parser.new.parse('{1960, 1961-12}')
        d.map { |x| [x.year,x.month] }.should == [[1960,1],[1961,12]]
      end
      
      it 'parses choice lists (One of the years 1667, 1668, 1670, 1671, 1672)' do
        d = Parser.new.parse('[1667,1668, 1670..1672]')
        d.map(&:year).should == [1667,1668,1670,1671,1672]
      end

      it 'parses choice lists (December 3, 1760 or some earlier date)' do
        d = Parser.new.parse('[..1760-12-03]')
        d.map(&:to_s).should == ['1760-12-03']
      end

      it 'parses choice lists (December 1760 or some later month)' do
        d = Parser.new.parse('[1760-12..]')
        d.map { |x| [x.year,x.month] }.should == [[1760,12]]
      end

      it 'parses choice lists (January or February of 1760 or December 1760 or some later month)' do
        d = Parser.new.parse('[1760-01, 1760-02, 1760-12..]')
        d.length.should == 3
      end
      
      it 'parses intern unspecified "199u-01-01"' do
        Parser.new.parse('199u-01-01').unspecified.to_s.should == 'sssu-ss-ss'
      end
      
      it 'parses intern unspecified "19uu-01-01"' do
        Parser.new.parse('19uu-01-01').unspecified.to_s.should == 'ssuu-ss-ss'
      end

      it 'parses intern unspecified "199u-uu-01"' do
        Parser.new.parse('199u-uu-01').unspecified.to_s.should == 'sssu-uu-ss'
      end
      
      it 'parses intern unspecified "19uu-uu-01"' do
        Parser.new.parse('19uu-uu-01').unspecified.to_s.should == 'ssuu-uu-ss'
      end

      it 'parses intern unspecified "199u-uu-uu"' do
        Parser.new.parse('199u-uu-uu').unspecified.to_s.should == 'sssu-uu-uu'
      end
      
      it 'parses intern unspecified "19uu-uu-uu"' do
        Parser.new.parse('19uu-uu-uu').unspecified.to_s.should == 'ssuu-uu-uu'
      end

      it 'parses intern unspecified "199u-01-uu"' do
        Parser.new.parse('199u-01-uu').unspecified.to_s.should == 'sssu-ss-uu'
      end
      
      it 'parses intern unspecified "19uu-01-uu"' do
        Parser.new.parse('19uu-01-uu').unspecified.to_s.should == 'ssuu-ss-uu'
      end

      it 'parses intern unspecified "1999-uu-01"' do
        Parser.new.parse('1999-uu-01').unspecified.to_s.should == 'ssss-uu-ss'
      end
      
    end
  end
end
