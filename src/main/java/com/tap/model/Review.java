package com.tap.model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int restId;
    private int userId;
    private String userName;
    private int rating;
    private String comment;
    private Timestamp createdDate;

    public Review() {
    }

    public Review(int restId, int userId, String userName, int rating, String comment) {
        this.restId = restId;
        this.userId = userId;
        this.userName = userName;
        this.rating = rating;
        this.comment = comment;
    }

    public Review(int reviewId, int restId, int userId, String userName, int rating, String comment, Timestamp createdDate) {
        this.reviewId = reviewId;
        this.restId = restId;
        this.userId = userId;
        this.userName = userName;
        this.rating = rating;
        this.comment = comment;
        this.createdDate = createdDate;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getRestId() {
        return restId;
    }

    public void setRestId(int restId) {
        this.restId = restId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "Review [reviewId=" + reviewId + ", restId=" + restId + ", userId=" + userId + ", userName=" + userName
                + ", rating=" + rating + ", comment=" + comment + ", createdDate=" + createdDate + "]";
    }
}
