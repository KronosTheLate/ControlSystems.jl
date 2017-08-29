@testset "test_discrete" begin

C_111 = ss([-5], [2], [3], [0])
C_212 = ss([-5 -3; 2 -9], [1; 2], eye(2), [0; 0])
C_221 = ss([-5 -3; 2 -9], [1 0; 0 2], [1 0], [0 0])
C_222_d = ss([-5 -3; 2 -9], [1 0; 0 2], eye(2), eye(2))

@test c2d(ss(4*eye(2)), 0.5, :zoh) == (ss(4*eye(2), 0.5), zeros(0, 2))
@test c2d(ss(4*eye(2)), 0.5, :foh) == (ss(4*eye(2), 0.5), zeros(0, 2))
@test_c2d(c2d(C_111, 0.01, :zoh),
ss([0.951229424500714], [0.019508230199714396], [3], [0], 0.01), [1 0])
@test_c2d(c2d(C_111, 0.01, :foh),
ss([0.951229424500714], [0.01902855227625244], [3], [0.029506188017136226], 0.01),
[1 -0.009835396005712075])
@test_c2d(c2d(C_212, 0.01, :zoh),
ss([0.9509478368863918 -0.027970882212682433; 0.018647254808454958 0.9136533272694819],
[0.009466805409666932; 0.019219966830212765], eye(2), [0; 0], 0.01),
[1 0 0; 0 1 0])
@test_c2d(c2d(C_212, 0.01, :foh),
ss([0.9509478368863921 -0.027970882212682433; 0.018647254808454954 0.913653327269482],
[0.008957940478201584; 0.018468989584974498], eye(2), [0.004820885889482196;
0.009738343195298675], 0.01), [1 0 -0.004820885889482196; 0 1 -0.009738343195298675])
@test_c2d(c2d(C_221, 0.01, :zoh),
ss([0.9509478368863918 -0.027970882212682433; 0.018647254808454958 0.9136533272694819],
[0.009753161420545834 -0.0002863560108789034; 9.54520036263011e-5 0.019124514826586465],
[1.0 0.0], [0.0 0.0], 0.01), [1 0 0 0; 0 1 0 0])
@test_c2d(c2d(C_221, 0.01, :foh),
ss([0.9509478368863921 -0.027970882212682433; 0.018647254808454954 0.913653327269482],
[0.009511049106772921 -0.0005531086285713394; 0.00018436954285711309 0.018284620042117387],
[1 0], [0.004917457305816479 -9.657141633428213e-5], 0.01),
[1 0 -0.004917457305816479 9.657141633428213e-5;
0 1 -3.219047211142736e-5 -0.009706152723187249])
@test_c2d(c2d(C_222_d, 0.01, :zoh),
ss([0.9509478368863918 -0.027970882212682433; 0.018647254808454958 0.9136533272694819],
[0.009753161420545834 -0.0002863560108789034; 9.54520036263011e-5 0.019124514826586465],
eye(2), eye(2), 0.01), [1 0 0 0; 0 1 0 0])
@test_c2d(c2d(C_222_d, 0.01, :foh),
ss([0.9509478368863921 -0.027970882212682433; 0.018647254808454954 0.913653327269482],
[0.009511049106772921 -0.0005531086285713394; 0.00018436954285711309 0.018284620042117387],
eye(2), [1.0049174573058164 -9.657141633428213e-5; 3.219047211142736e-5 1.0097061527231872], 0.01),
[1 0 -0.004917457305816479 9.657141633428213e-5; 0 1 -3.219047211142736e-5 -0.009706152723187249])

# ERRORS
@test_throws ErrorException c2d(ss([1], [2], [3], [4], 0.01), 0.01)   # Already discrete
@test_throws ErrorException c2d(ss([1], [2], [3], [4], -1), 0.01)     # Already discrete
end
