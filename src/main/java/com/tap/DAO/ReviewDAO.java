package com.tap.DAO;

import java.util.List;
import com.tap.model.Review;

public interface ReviewDAO {
    void addReview(Review r);
    List<Review> getReviewsByRestaurant(int restId);
    double getAverageRating(int restId);
}
