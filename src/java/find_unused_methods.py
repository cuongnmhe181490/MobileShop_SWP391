import os
import re

dao_base_dir = r"c:\Users\Hai Vu\Downloads\MobileShop_SWP391-main\src\java\dao"
search_dirs = [
    r"c:\Users\Hai Vu\Downloads\MobileShop_SWP391-main\src",
    r"c:\Users\Hai Vu\Downloads\MobileShop_SWP391-main\web"
]

def get_dao_files(directory):
    dao_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".java"):
                dao_files.append(os.path.join(root, file))
    return dao_files

def extract_methods(file_path):
    methods = []
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        # Basic regex to find public/protected methods
        # Matches: public|protected [Type] [MethodName]([Args])
        pattern = r"(?:public|protected)\s+[\w<>[\]]+\s+(\w+)\s*\("
        matches = re.finditer(pattern, content)
        for match in matches:
            methods.append(match.group(1))
    return list(set(methods))

def find_usages(method_name, search_dirs):
    count = 0
    usages = []
    for directory in search_dirs:
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.endswith((".java", ".jsp", ".jspf")):
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                            if method_name in content:
                                count += content.count(method_name)
                                usages.append(file_path)
                    except:
                        pass
    return count, list(set(usages))

def main():
    dao_files = get_dao_files(dao_base_dir)
    results = []
    
    for dao_file in dao_files:
        methods = extract_methods(dao_file)
        rel_path = os.path.relpath(dao_file, dao_base_dir)
        for method in methods:
            # Skip common names that might lead to false positives if not careful
            # but for now let's just count.
            total_count, files = find_usages(method, search_dirs)
            
            # If the method is only used in this DAO file, it's potentially unused.
            # We check if all files where it's found are just this DAO file.
            only_in_dao = True
            for f in files:
                if f != dao_file:
                    only_in_dao = False
                    break
            
            if only_in_dao:
                results.append({
                    "dao": rel_path,
                    "method": method,
                    "count": total_count
                })
                
    print("Potentially unused methods (only found in their own DAO file):")
    for res in results:
        print(f"{res['dao']}: {res['method']} (found {res['count']} times in its own file)")

if __name__ == "__main__":
    main()
