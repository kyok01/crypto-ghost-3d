import os


def read_vector_file(file_name: str):
    DIR = os.getcwd()
    with open(os.path.join(DIR, f"file/{file_name}")) as vector_file:
        vector = vector_file.read()
    return vector


def v_check():
    vector = read_vector_file("v_check_convert.txt")
    decode_vector = read_vector_file("v.txt").split("\n")

    not_exists_counter = 0
    for decode_v in decode_vector[:-1]:
        decode_v_list = decode_v.split(" ")
        if "-" in decode_v_list[1]:
            decode_v_list[1] = str(decode_v_list[1]).ljust(9, "0")
        else:
            decode_v_list[1] = str(decode_v_list[1]).ljust(8, "0")
        if "-" in decode_v_list[2]:
            decode_v_list[2] = str(decode_v_list[2]).ljust(9, "0")
        else:
            decode_v_list[2] = str(decode_v_list[2]).ljust(8, "0")
        if "-" in decode_v_list[3]:
            decode_v_list[3] = str(decode_v_list[3]).ljust(9, "0")
        else:
            decode_v_list[3] = str(decode_v_list[3]).ljust(8, "0")
        decode_v_str = " ".join(decode_v_list)
        # print(len(decode_v_str))
        # print(len("v 0.500000 0.866025 0.000000"))
        if decode_v_str[:-1] in vector:
            print("exists")
        else:
            print("not exists")
            print(decode_v_str)
            not_exists_counter += 1
    print(f"存在しなかった数: {not_exists_counter}")


def vn_check():
    vector = read_vector_file("vn_check.txt")
    decode_vector = read_vector_file("vn.txt").split("\n")

    not_exists_counter = 0
    for decode_v in decode_vector:
        decode_v_list = decode_v.split(" ")
        if "-" in decode_v_list[1]:
            decode_v_list[1] = str(decode_v_list[1]).ljust(7, "0")
        else:
            decode_v_list[1] = str(decode_v_list[1]).ljust(6, "0")
        if "-" in decode_v_list[2]:
            decode_v_list[2] = str(decode_v_list[2]).ljust(7, "0")
        else:
            decode_v_list[2] = str(decode_v_list[2]).ljust(6, "0")
        if "-" in decode_v_list[3]:
            decode_v_list[3] = str(decode_v_list[3]).ljust(7, "0")
        else:
            decode_v_list[3] = str(decode_v_list[3]).ljust(6, "0")
        decode_v_str = " ".join(decode_v_list)
        # print(len(decode_v_str))
        # print(len("v 0.500000 0.866025 0.000000"))
        if decode_v_str[:-1] in vector:
            print("exists")
        else:
            print("not exists")
            print(decode_v_str)
            not_exists_counter += 1
    print(f"存在しなかった数: {not_exists_counter}")


if __name__ == "__main__":
    # v_check()
    vn_check()
