function calculator(a,b)
% Helps to do some basic calculations for the given inputs
%
% Syntax :
%      calculator(a,b) it will ask for the different operations
%
%      Enter the Option MENU 1.ADD 2.SUBTRACT 3.MULTIPLY  4.DIVIDE 5.MODULUS
%      Then, select required operation if you select 1 then it will give
%      the addition of 2 input arguments
% Sample :
%      calculator(13,14) and if you select '1' then it returns 27

%
firstValue = a;
secondValue = b;
operation = input(' Enter the Option \n MENU \n 1.ADD \n 2.SUBTRACT \n 3.MULTIPLY \n 4.DIVIDE \n 5.MODULUS \n');
switch(operation)
    case 1
        Result = addition(firstValue,secondValue);
    case 2
        Result = subtraction(firstValue,secondValue);
    case 3
        Result = multiplication(firstValue,secondValue);
    case 4
        Result = division(firstValue,secondValue);
    case 5
        Result = modulusop(firstValue,secondValue);
    otherwise
        disp('Invalid Option');
        Result = 0;        
end
fprintf('Result : %d \n', Result);
end

