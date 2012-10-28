describe Movie do
  describe "find_by_director" do
    it "" do
      movie = Movie.create(:title => 'Star Wars 2',
                           :rating => 'PG',
                           :director => 'George Lucas',
                           :release_date => '1977-05-25');
      movies = Movie.find_by_director('George Lucas')
      movies.each each do |movie|
        movie.director.should eq('George Lucas')
      end
    end
  end
end
