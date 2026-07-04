package com.tap.DAOimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.DAO.ReviewDAO;
import com.tap.model.Review;
import com.tap.util.DBConnection;

public class ReviewDAOimpl implements ReviewDAO {

    private static final String INSERT_QUERY = "INSERT INTO review(restId, userId, userName, rating, comment) VALUES(?,?,?,?,?)";
    private static final String SELECT_BY_REST_QUERY = "SELECT * FROM review WHERE restId=? ORDER BY createdDate DESC";
    private static final String AVG_RATING_QUERY = "SELECT AVG(rating) FROM review WHERE restId=?";

    @Override
    public void addReview(Review r) {
        Connection connection = DBConnection.getConnection();
        try {
            PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
            pstmt.setInt(1, r.getRestId());
            pstmt.setInt(2, r.getUserId());
            pstmt.setString(3, r.getUserName());
            pstmt.setInt(4, r.getRating());
            pstmt.setString(5, r.getComment());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Review> getReviewsByRestaurant(int restId) {
        Connection connection = DBConnection.getConnection();
        List<Review> list = new ArrayList<>();
        try {
            PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_REST_QUERY);
            pstmt.setInt(1, restId);
            ResultSet res = pstmt.executeQuery();
            while (res.next()) {
                list.add(new Review(
                    res.getInt("reviewId"),
                    res.getInt("restId"),
                    res.getInt("userId"),
                    res.getString("userName"),
                    res.getInt("rating"),
                    res.getString("comment"),
                    res.getTimestamp("createdDate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public double getAverageRating(int restId) {
        Connection connection = DBConnection.getConnection();
        double avg = 0.0;
        try {
            PreparedStatement pstmt = connection.prepareStatement(AVG_RATING_QUERY);
            pstmt.setInt(1, restId);
            ResultSet res = pstmt.executeQuery();
            if (res.next()) {
                avg = res.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return avg;
    }
}
