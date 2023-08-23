function normalized_data = normalize_data(data)
    % 원본 데이터의 x 좌표
    original_x = linspace(0, 1, length(data));
    % 정규화된 데이터의 x 좌표 (101개의 데이터 포인트)
    normalized_x = linspace(0, 1, 101);
    % 보간을 사용하여 데이터 정규화
    normalized_data = interp1(original_x, data, normalized_x, 'linear');
end

