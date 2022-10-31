import math
import os


def create_base_obj_vector(radius: int, vector: list, round_num: int) -> str:
    angle = math.radians(360 // radius)

    sin_num = math.sin(angle)
    cos_num = math.cos(angle)

    next_x = round(cos_num * vector[0] + (sin_num * vector[1]) * -1, round_num)
    next_y = round(sin_num * vector[0] + cos_num * vector[1], round_num)

    return next_x, next_y


def create_v_vector(vector_base_list: list, vector: list, vector_z_inversion: list):
    # x軸マイナス
    vector += f"v {vector_base_list[2] * -1} {vector_base_list[1]} {vector_base_list[0]}\n"
    vector_z_inversion += f"v {vector_base_list[2] * -1} {vector_base_list[1] * -1} {vector_base_list[0]}\n"
    for vector_base_index in [2, 1]:
        vector += f"v {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2]}\n"
        vector_z_inversion += f"v {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2]}\n"

    # x軸y軸マイナス
    for vector_base_index in range(3):
        if str(vector_base_list[vector_base_index*3+2]) in "0.0":
            vector += f"v {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2]}\n"
            vector_z_inversion += f"v {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2]}\n"
        else:
            vector += f"v {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2] * -1}\n"
            vector_z_inversion += f"v {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2] * -1}\n"

    # y軸マイナス
    vector += f"v {vector_base_list[2]} {vector_base_list[1]} {vector_base_list[0] * -1}\n"
    vector_z_inversion += f"v {vector_base_list[2]} {vector_base_list[+1] * -1} {vector_base_list[0] * -1}\n"
    for vector_base_index in [2, 1]:
        vector += f"v {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2] * -1}\n"
        vector_z_inversion += f"v {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2] * -1}\n"

    return vector, vector_z_inversion


def create_vn_vector(vector_base_list: list, vector: list, vector_z_inversion: list):
    # x軸マイナス
    for vector_base_index in range(3):
        if vector_base_index == 0:
            vector += f"vn {vector_base_list[vector_base_index*3+2] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3]}\n"
            vector_z_inversion += f"vn {vector_base_list[vector_base_index*3+2] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3]}\n"
        else:
            vector += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2]}\n"
            vector_z_inversion += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2]}\n"

    # x軸y軸マイナス
    for vector_base_index in range(3):
        if str(vector_base_list[vector_base_index*3+2]) in "0.0":
            vector += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2]}\n"
            vector_z_inversion += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2]}\n"
        else:
            vector += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2] * -1}\n"
            vector_z_inversion += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2] * -1}\n"

    # y軸マイナス
    for vector_base_index in range(3):
        if vector_base_index == 0:
            vector += f"vn {vector_base_list[vector_base_index*3+2]} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3] * -1}\n"
            vector_z_inversion += f"vn {vector_base_list[vector_base_index*3+2]} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3] * -1}\n"
        # if str(vector[vector_base_index*3+2]) in "0.0":
            # vector += f"{vector_kind} {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2]}\n"
            # vector_z_inversion += f"{vector_kind} {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2]}\n"
        else:
            vector += f"vn {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2] * -1}\n"
            vector_z_inversion += f"vn {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2] * -1}\n"

    return vector, vector_z_inversion


def decode_obj(vector_kind: str, radius: int, vector: str, vector_list: list[float]) -> list:

    vector_base_list = vector_list
    vector_x = float(vector_list[0])
    vector_z = float(vector_list[1])
    vector_y = float(vector_list[2])

    if vector_kind == "v":
        round_num = 6
    elif vector_kind == "vn":
        round_num = 4

    vector_z_inversion = f"{vector_kind} {vector_list[0]} {vector_list[1] * -1} {vector_list[2]}\n"

    for _ in range(radius//4-1):
        next_vector_x, next_vector_y = create_base_obj_vector(radius, [vector_x, vector_y], round_num)
        vector_x = float(next_vector_x)
        vector_y = float(next_vector_y)
        vector_base_list.extend([next_vector_x, vector_z, next_vector_y])
        vector += f"{vector_kind} {next_vector_x} {vector_z} {next_vector_y}\n"
        vector_z_inversion += f"{vector_kind} {next_vector_x} {vector_z * -1} {next_vector_y}\n"

    print(f"vector_kind_base_list: {vector_base_list}")

    if vector_kind == "v":
        vector, vector_z_inversion = create_v_vector(vector_base_list, vector, vector_z_inversion)
    else:
        vector, vector_z_inversion = create_v_vector(vector_base_list, vector, vector_z_inversion)

    return vector, vector_z_inversion


def create_vector_file(file_name: str, vector_str: str):
    DIR = os.getcwd()
    with open(os.path.join(DIR, f"file/{file_name}"), "w+") as txt_file:
        txt_file.write(vector_str)


def create_f(v_vector: str, vn_vector: str, radius: int):
    f_mesh = ""
    vn_length = len(vn_vector.split("\n"))
    for vn_index in range(1, vn_length):
        if vn_index < radius:
            f_mesh += f"f {vn_index+1}/{vn_index}/{vn_index} 1/{vn_index}/{vn_index} {vn_index+2}/{vn_index}/{vn_index}\n"
        elif vn_index == radius:
            f_mesh += f"f {vn_index+1}/{vn_index}/{vn_index} 1/{vn_index}/{vn_index} {vn_index-10}/{vn_index}/{vn_index}\n"
        elif vn_index >= vn_length-radius:
            f_mesh += f"f {vn_index-2}/{vn_index}/{vn_index} 72/{vn_index}/{vn_index} {vn_index-1}/{vn_index}/{vn_index}\n"
        else:
            # f_mesh += f"f {vn_index-radius+1}/{vn_index}/{vn_index} {vn_index-radius+2}/{vn_index}/{vn_index} {vn_index}/{vn_index}/{vn_index} {vn_index+1}/{vn_index}/{vn_index}\n"
            f_mesh += f"f {vn_index-radius+2}/{vn_index}/{vn_index} {vn_index+1}/{vn_index}/{vn_index} {vn_index-radius+1}/{vn_index}/{vn_index} {vn_index}/{vn_index}/{vn_index}\n"

    return f_mesh

if __name__ == "__main__":
    """
    radius: 12

    v
    # 1段目
    - zが1番大きく、xが一番大きい。
    vector: 0.500000 0.866025 0.000000

    # 2段目
    - zが2番目に大きく、xが一番大きい。
    vector: 0.866026 0.500000 0.000000

    # 3段目
    - zが3番目に大きく、xが一番大きい。
    vector: 1.000000 -0.000000 0.000000

    vn
    # 1段目
    - zが1番大きく、xが一番大きい。
    vector: 0.2582 0.9636 0.0692
    v_coordinate: 0.500000 0.866025 0.000000

    # 2段目
    - zが2番目に大きく、xが一番大きい。
    vector: 0.6947 0.6947 0.1862

    # 3段目
    - zが3番目に大きく、xが一番大きい。
    vector: 0.9351 0.2506 0.2506
    """

    radius = 12

    # v
    v_top, v_top_inversion = decode_obj("v", radius, "v 0.500000 0.866025 0.000000\n", [0.500000, 0.866025, 0.000000])
    v_second, v_second_inversion = decode_obj("v", radius, "v 0.866026 0.500000 0.000000\n", [0.866026, 0.500000, 0.000000])
    v_third, v_third_inversion = decode_obj("v", radius, "v 1.000000 -0.000000 0.000000\n", [1.000000, -0.000000, 0.000000])

    # vn
    vn_top, vn_top_inversion = decode_obj("vn", radius, "vn 0.2582 0.9636 0.0692\n", [0.2582, 0.9636, 0.0692])
    vn_second, vn_second_inversion = decode_obj("vn", radius, "vn 0.6947 0.6947 0.1862\n", [0.6947, 0.6947, 0.1862])
    vn_third, vn_third_inversion = decode_obj("vn", radius, "vn 0.9351 0.2506 0.2506\n", [0.9351, 0.2506, 0.2506])

    # print(f"vn_top: \n{vn_top}")
    # print(f"vn_second: \n{vn_second}")
    # print(f"vn_third: \n{vn_third}")
    # print(f"vn_third_inversion: \n{vn_third_inversion}")
    # print(f"vn_second_inversion: \n{vn_second_inversion}")
    # print(f"vn_top_inversion: \n{vn_top_inversion}")

    # print(f"v_top: \n{v_top}")
    # print(f"v_second: \n{v_second}")
    # print(f"v_third: \n{v_third}")
    # print(f"v_second_inversion: \n{v_second_inversion}")
    # print(f"v_top_inversion: \n{v_top_inversion}")

    v_vector = f"v -0.000000 1.000000 0.000000\n{v_top}{v_second}{v_third}{v_second_inversion}{v_top_inversion}v 0.000000 -1.000000 0.000000\n"
    vn_vector = f"{vn_top}{vn_second}{vn_third}{vn_third_inversion}{vn_second_inversion}{vn_top_inversion}"

    # write txt file
    create_vector_file("v.txt", v_vector)
    create_vector_file("vn.txt", vn_vector)

    f_mesh = create_f(v_vector, vn_vector, radius)
    create_vector_file("f.txt", f_mesh)


# 1 v 0.000000 0.866025 -0.500000
# 5 v 0.250000 0.866025 -0.433013
# 10 v 0.433013 0.866025 -0.250000
# 15 v 0.500000 0.866025 0.000000
# 20 v 0.433013 0.866025 0.250000
# 25 v 0.250000 0.866025 0.433013
# 31 v 0.000000 0.866025 0.500000
# 36 v -0.250000 0.866025 0.433013
# 42 v -0.433013 0.866025 0.250000
# 47 v -0.500000 0.866025 0.000000
# 52 v -0.433013 0.866025 -0.250000
# 57 v -0.250000 0.866025 -0.433013

# v -0.000000 1.000000 0.000000
# v 0.500000 0.866025 0.000000
# v 0.433013 0.866025 0.25
# v 0.25 0.866025 0.433013
# v -0.5 0.866025 0.0
# v -0.433013 0.866025 0.25
# v -0.25 0.866025 0.433013
# v -0.5 0.866025 0.0
# v -0.433013 0.866025 -0.25
# v -0.25 0.866025 -0.433013
# v 0.5 0.866025 0.0
# v 0.433013 0.866025 0.25

# 24 30 35

# 24 vn 0.2582 0.9636 0.0692
# 30 vn 0.1890 0.9636 0.1890
# 35 0.0692 0.9636 0.2582
