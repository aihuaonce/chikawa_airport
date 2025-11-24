import re

type_mapping = {
    "IntColumn": "models.IntegerField()",
    "TextColumn": "models.TextField()",
    "BoolColumn": "models.BooleanField()",
    "DateTimeColumn": "models.DateTimeField()",
    "BlobColumn": "models.BinaryField()",
}

with open("tables.dart", "r", encoding="utf-8") as f:
    lines = f.readlines()

current_class = None
fields = []
models_output = []

for line in lines:
    line = line.strip()
    # 偵測 class
    class_match = re.match(r"class (\w+) extends Table", line)
    if class_match:
        if current_class:
            # 輸出上一個 class
            models_output.append(f"class {current_class}(models.Model):")
            if fields:
                for name, field_type in fields:
                    models_output.append(f"    {name} = {field_type}")
            else:
                models_output.append("    pass")
            models_output.append("")  # 空行
        current_class = class_match.group(1)
        fields = []
        continue

    # 偵測欄位
    col_match = re.match(r"\w+ get (\w+) => (\w+)\(.*\);", line)
    if col_match:
        name = col_match.group(1)
        if name == "id":  # 忽略 id 欄位
            continue
        dtype = col_match.group(2)
        django_type = type_mapping.get(dtype, "models.TextField()")
        fields.append((name, django_type))

# 輸出最後一個 class
if current_class:
    models_output.append(f"class {current_class}(models.Model):")
    if fields:
        for name, field_type in fields:
            models_output.append(f"    {name} = {field_type}")
    else:
        models_output.append("    pass")

# 寫入 models.py
with open("models.py", "w", encoding="utf-8") as f:
    f.write("from django.db import models\n\n")
    f.write("\n".join(models_output))

print("models.py 生成完成！")
