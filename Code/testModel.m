function model = testModel(model, A, B)

B_prediction = A * model.W;
model.MSE    = norm(B - B_prediction);

end