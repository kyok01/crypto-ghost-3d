import math
import os


def create_base_obj_vector(div_num_h: int, vector: list, round_num: int) -> str:
    """sin, cos計算

    Args:
        div_num_h (int): 分割数
        vector (list): ベクトル
        round_num (int): 丸め込む桁数

    Returns:
        str: _description_
    """
    angle = math.radians(360 // div_num_h)

    sin_num = math.sin(angle)
    cos_num = math.cos(angle)

    next_x = round(cos_num * vector[0] + (sin_num * vector[1]) * -1, round_num)
    next_y = round(sin_num * vector[0] + cos_num * vector[1], round_num)

    return next_x, next_y


def create_v_vector(vector_base_list: list, vector: str, vector_z_inversion: list):
    """vを生成

    Args:
        vector_base_list (list): ベースとなるベクトルの配列
        vector (list): vを文字列にしたもの。生成したvが結合されていく。
        vector_z_inversion (list): vをz軸で反転したもの。生成したz軸で反転したvが結合されていく。

    Returns:
        _type_: _description_
    """
    # x軸マイナス
    # 左上の箇所のため、x軸の値が0になる。
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
    # 右下の箇所のため、y軸の値が0になる。
    vector += f"v {vector_base_list[2]} {vector_base_list[1]} {vector_base_list[0] * -1}\n"
    vector_z_inversion += f"v {vector_base_list[2]} {vector_base_list[+1] * -1} {vector_base_list[0] * -1}\n"
    for vector_base_index in [2, 1]:
        vector += f"v {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2] * -1}\n"
        vector_z_inversion += f"v {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2] * -1}\n"

    return vector, vector_z_inversion


def create_vn_vector(vector_base_list: list, vector: list, vector_z_inversion: list):
    """vnを生成

    Args:
        vector_base_list (list): ベースとなるベクトルの配列
        vector (list): vnを文字列にしたもの。生成したvnが結合されていく。
        vector_z_inversion (list): vnをz軸で反転したもの。生成したz軸で反転したvnが結合されていく。

    Returns:
        _type_: _description_
    """
    # x軸マイナス
    for vector_base_index in range(3):
        vector += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2]}\n"
        vector_z_inversion += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2]}\n"

    # x軸y軸マイナス
    for vector_base_index in range(3):
        vector += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2] * -1}\n"
        vector_z_inversion += f"vn {vector_base_list[vector_base_index*3] * -1} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2] * -1}\n"

    # y軸マイナス
    for vector_base_index in range(3):
        vector += f"vn {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1]} {vector_base_list[vector_base_index*3+2] * -1}\n"
        vector_z_inversion += f"vn {vector_base_list[vector_base_index*3]} {vector_base_list[vector_base_index*3+1] * -1} {vector_base_list[vector_base_index*3+2] * -1}\n"

    return vector, vector_z_inversion

def create_vt_vector(div_num_h: int, div_num_v: int):
    """vtを生成
    Args:
        div_num_h: 水平方向の分割数。
        div_num_v: 垂直方向の分割数。
    """
    vector_str = f""
    num_of_vt = div_num_h * (div_num_v + 1) + (div_num_v - 1)

    # 縦横の１マスの長さをユニットとして定義。
    unit_h = 1 / div_num_h
    unit_h_half = unit_h / 2
    unit_v = 1 / div_num_v

    # 上部頂点がdiv_num_h個ある。y座標は常に１。
    for index in range(div_num_h):
        x = round(unit_h_half + index * unit_h, 6)
        vector_str += f"vt {x} {1}\n"

    # 側面の四角形に所属する頂点が num_of_vt - 2 * div_num_h 個ある。
    for index in range(div_num_h, num_of_vt - div_num_h):
        x = round(((index + 1) % (div_num_h + 1)) * unit_h, 6)
        y = round((div_num_v - (index + 1) // (div_num_h + 1)) * unit_v, 6)
        vector_str += f"vt {x} {y}\n"

    # 下部頂点がdiv_num_h個ある。y座標は常に０。
    for index in range(div_num_h):
        x = round(unit_h_half + index * unit_h, 6)
        vector_str += f"vt {x} {0}\n"

    return vector_str


def decode_obj(vector_kind: str, div_num_h: int, vector: str, vector_list: list[float]) -> list:
    """vとvnを生成

    Args:
        vector_kind (str): vを生成するか、vnを生成するか。
        div_num_h (int): 水平方向の分割数
        vector (str): 1つのベクトル。ここにどんどんv又はvnが結合されていく。
        vector_list (list[float]): 1つのベクトル。

    Returns:
        list: vector
    """
    vector_base_list = vector_list
    vector_x = float(vector_list[0])
    vector_z = float(vector_list[1])
    vector_y = float(vector_list[2])

    # vは小数点6桁、vnは小数点が4桁
    if vector_kind == "v":
        round_num = 6
    elif vector_kind == "vn":
        round_num = 4

    vector_z_inversion = f"{vector_kind} {vector_list[0]} {vector_list[1] * -1} {vector_list[2]}\n"

    # ベースとなるvやvnを生成（この値を使用して-をつけたりすることでvやvnを生成していく）。
    for _ in range(div_num_h//4-1):
        next_vector_x, next_vector_y = create_base_obj_vector(div_num_h, [vector_x, vector_y], round_num)
        vector_x = float(next_vector_x)
        vector_y = float(next_vector_y)
        vector_base_list.extend([next_vector_x, vector_z, next_vector_y])
        vector += f"{vector_kind} {next_vector_x} {vector_z} {next_vector_y}\n"
        vector_z_inversion += f"{vector_kind} {next_vector_x} {vector_z * -1} {next_vector_y}\n"

    # ベースとなるvやvnを確認
    print(f"{vector_kind}のvector_base_list: {vector_base_list}")

    # v又はvnを生成
    if vector_kind == "v":
        vector, vector_z_inversion = create_v_vector(vector_base_list, vector, vector_z_inversion)
    else:
        vector, vector_z_inversion = create_vn_vector(vector_base_list, vector, vector_z_inversion)

    return vector, vector_z_inversion


def create_vector_file(file_name: str, vector_str: str):
    DIR = os.getcwd()
    with open(os.path.join(DIR, f"file/{file_name}"), "w+") as txt_file:
        txt_file.write(vector_str)


def create_f(v_vector: str, vn_vector: str, div_num_h: int) -> str:
    """fを生成。

    Args:
        v_vector (str): vを文字列として受け取る。
        vn_vector (str): vnを文字列として受け取る。
        div_num_h (int): 水平方向の分割数

    Returns:
        sre: fの文字列を返す。
    """
    f_mesh = ""
    vn_length = len(vn_vector.split("\n"))
    for vn_index in range(1, vn_length):
        if vn_index < div_num_h:
            f_mesh += f"f {vn_index+1}/{vn_index}/{vn_index} 1/{vn_index}/{vn_index} {vn_index+2}/{vn_index}/{vn_index}\n"
        elif vn_index == div_num_h:
            f_mesh += f"f {vn_index+1}/{vn_index}/{vn_index} 1/{vn_index}/{vn_index} {vn_index-10}/{vn_index}/{vn_index}\n"
        elif vn_index == vn_length-1:
            f_mesh += f"f {vn_index-div_num_h*2+2}/{vn_index}/{vn_index} 62/{vn_index}/{vn_index} {vn_index-div_num_h+1}/{vn_index}/{vn_index}\n"
        elif vn_index >= vn_length-div_num_h:
            f_mesh += f"f {vn_index-div_num_h+2}/{vn_index}/{vn_index} 62/{vn_index}/{vn_index} {vn_index-div_num_h+1}/{vn_index}/{vn_index}\n"
        elif vn_index % div_num_h == 0:
            f_mesh += f"f {vn_index-div_num_h*2+2}/{vn_index}/{vn_index} {vn_index-div_num_h+2}/{vn_index}/{vn_index} {vn_index+1}/{vn_index}/{vn_index} {vn_index-div_num_h+1}/{vn_index}/{vn_index}\n"
        else:
            # f_mesh += f"f {vn_index-div_num_h+1}/{vn_index}/{vn_index} {vn_index-div_num_h+2}/{vn_index}/{vn_index} {vn_index}/{vn_index}/{vn_index} {vn_index+1}/{vn_index}/{vn_index}\n"
            f_mesh += f"f {vn_index-div_num_h+2}/{vn_index}/{vn_index} {vn_index+2}/{vn_index}/{vn_index} {vn_index+1}/{vn_index}/{vn_index} {vn_index-div_num_h+1}/{vn_index}/{vn_index}\n"

    return f_mesh


def create_obj_file(v_vector: str, vn_vector: str, f_mesh):
    """objファイルの作成

    Args:
        v_vector (str): vを文字列として受け取る。
        vn_vector (str): vnを文字列として受け取る。
        f_mesh (_type_): fを文字列として受け取る。
    """

    obj = "# Blender v3.2.2 OBJ File: ''\n# www.blender.org\nmtllib sphere_12_6.mtl\no 球_球.001\n"
    obj += v_vector
    obj += vn_vector
    obj += "usemtl None\ns off\n"
    obj += f_mesh

    create_vector_file("create_obj_12_6.obj", obj)


if __name__ == "__main__":
    """
    div_num_h: 12

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

    div_num_h = 12

    # v
    v_top, v_top_inversion = decode_obj("v", div_num_h, "v 0.500000 0.866025 0.000000\n", [0.500000, 0.866025, 0.000000])
    v_second, v_second_inversion = decode_obj("v", div_num_h, "v 0.866026 0.500000 0.000000\n", [0.866026, 0.500000, 0.000000])
    v_third, v_third_inversion = decode_obj("v", div_num_h, "v 1.000000 -0.000000 0.000000\n", [1.000000, -0.000000, 0.000000])

    # vn
    vn_top, vn_top_inversion = decode_obj("vn", div_num_h, "vn 0.2582 0.9636 0.0692\n", [0.2582, 0.9636, 0.0692])
    vn_second, vn_second_inversion = decode_obj("vn", div_num_h, "vn 0.6947 0.6947 0.1862\n", [0.6947, 0.6947, 0.1862])
    vn_third, vn_third_inversion = decode_obj("vn", div_num_h, "vn 0.9351 0.2506 0.2506\n", [0.9351, 0.2506, 0.2506])

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

    # vの一番高い/低い頂点を追加。
    v_vector = f"v -0.000000 1.000000 0.000000\n{v_top}{v_second}{v_third}{v_second_inversion}{v_top_inversion}v 0.000000 -1.000000 0.000000\n"
    vn_vector = f"{vn_top}{vn_second}{vn_third}{vn_third_inversion}{vn_second_inversion}{vn_top_inversion}"
    vt_vector = create_vt_vector(12, 6)

    # テキストファイルにvとvnを書き出す。
    create_vector_file("v.txt", v_vector)
    create_vector_file("vn.txt", vn_vector)
    create_vector_file("vt.txt", vt_vector)

    # fを生成
    f_mesh = create_f(v_vector, vn_vector, div_num_h)
    # テキストファイルにfを書き出す。
    create_vector_file("f.txt", f_mesh)

    # objファイル作成
    create_obj_file(v_vector, vn_vector, f_mesh)


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
