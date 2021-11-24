function finishGood
    S = load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
    sound(S.y, S.Fs);
end