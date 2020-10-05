# Creating Transfer Functions
```@meta
DocTestSetup = quote
    using ControlSystems
end
```

## using the ```tf()``` function
The basic syntax for creating a transfer function is
```julia
tf(num, den, Ts=0)
```
where `num` and `den` are the polynomial coefficients of the numerator and denominator of the polynomial and `Ts` is the sample time.
### Example:
```julia
julia> tf([1.0],[1,2,1])

TransferFunction{Continuous,ControlSystems.SisoRational{Float64}}
         1.0
---------------------
1.0*s^2 + 2.0*s + 1.0

Continuous-time transfer function model
```

The transfer functions created using this method will be of type `TransferFunction{SisoRational}`.



Some times you only have an expression for the transfer-function, and you don't have it reduced to a fraction with polynomials of ```s``` as numerator and denomenator. No problem! The following method for defining transfer-functions finds the polynomial factors and defines the transfer-function for you:
### Example:
```julia
julia> s = tf("s")

TransferFunction{Continuous,ControlSystems.SisoRational{Int64}}
s
-
1

Continuous-time transfer function model
```

We can now use ```s```to define the above transfer-function like this:
```julia
julia> 1/(s^2+2s+1)

TransferFunction{Continuous,ControlSystems.SisoRational{Int64}}
      1
-------------
s^2 + 2*s + 1

Continuous-time transfer function model
```

This was of course a trivial example, as the expression was already reduced. But as long as the expression only contains numbers and s (with s defined as shown), the transfer-function is defined correctly.
Note that due to rounding-errors when dealing with floating point numbers, the transfer-function returned will sometimes show something like 1.99999999999 instead of 2.

## zpk - Pole-Zero-Gain Representation
Sometimes it's better to represent the transfer function by its poles, zeros and gain, this can be done using
```julia
zpk(zeros, poles, gain, Ts=0)
```
where `zeros` and `poles` are `Vectors` of the zeros and poles for the system and `gain` is a gain coefficient.
### Example
<<<<<<< HEAD
```jldoctest
zpk([-1.0,1], [-5, -10], 2)

# output
=======
```julia
julia> zpk([-1.0,1], [-5, -10], 2)
>>>>>>> ef64701 (Adding example for s=tf("s") syntax)

TransferFunction{Continuous,ControlSystems.SisoZpk{Float64,Float64}}
   (1.0*s + 1.0)(1.0*s - 1.0)
2.0---------------------------
   (1.0*s + 5.0)(1.0*s + 10.0)

Continuous-time transfer function model
```

The transfer functions created using this method will be of type `TransferFunction{SisoZpk}`.

## Converting between types
It is sometime useful to convert one representation to another, this is possible using the same functions, for example
<<<<<<< HEAD
```jldoctest
tf(zpk([-1], [1], 2, 0.1))

# output
=======
```julia
julia>  tf(zpk([-1], [1], 2, 0.1))
>>>>>>> ef64701 (Adding example for s=tf("s") syntax)

TransferFunction{Discrete{Float64},ControlSystems.SisoRational{Int64}}
2*z + 2
-------
 z - 1

Sample Time: 0.1 (seconds)
Discrete-time transfer function model
```


# Creating State-Space Systems
A state-space system is created using
```julia
ss(A,B,C,D,Ts=0)
```
and they behave similarily to transfer functions. State-space systems with heterogeneous matrix types are also available, which can be used to create systems with static or sized matrices, e.g.,
```jldoctest HSS; output=false
using StaticArrays
import ControlSystems.HeteroStateSpace
@inline to_static(a::Number) = a
@inline to_static(a::AbstractArray) = SMatrix{size(a)...}(a)
@inline to_sized(a::Number) = a
@inline to_sized(a::AbstractArray) = SizedArray{Tuple{size(a)...}}(a)
function HeteroStateSpace(A,B,C,D,Ts=0,f::F=to_static) where F
    HeteroStateSpace(f(A),f(B),f(C),f(D),Ts)
end
@inline HeteroStateSpace(s,f) = HeteroStateSpace(s.A,s.B,s.C,s.D,s.timeevol,f)
ControlSystems._string_mat_with_headers(a::SizedArray) = ControlSystems._string_mat_with_headers(Matrix(a)); # Overload for printing purposes

# output

```
Notice the different matrix types used
```jldoctest HSS
julia> sys = ss([-5 0; 0 -5],[2; 2],[3 3],[0])
StateSpace{Continuous,Int64,Array{Int64,2}}
A =
 -5   0
  0  -5
B =
 2
 2
C =
 3  3
D =
 0

Continuous-time state-space model

julia> HeteroStateSpace(sys, to_static)
HeteroStateSpace{Continuous,SArray{Tuple{2,2},Int64,2,4},SArray{Tuple{2,1},Int64,2,2},SArray{Tuple{1,2},Int64,2,2},SArray{Tuple{1,1},Int64,2,1}}
A =
 -5   0
  0  -5
B =
 2
 2
C =
 3  3
D =
 0

Continuous-time state-space model

julia> HeteroStateSpace(sys, to_sized)
HeteroStateSpace{Continuous,SizedArray{Tuple{2,2},Int64,2,2},SizedArray{Tuple{2,1},Int64,2,2},SizedArray{Tuple{1,2},Int64,2,2},SizedArray{Tuple{1,1},Int64,2,2}}
A =
 -5   0
  0  -5
B =
 2
 2
C =
 3  3
D =
 0

Continuous-time state-space model
```
