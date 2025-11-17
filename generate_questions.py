import json, random
from collections import defaultdict

# Templates to combine with keywords
TEMPLATES = [
    "What is {X}?",
    "Explain {X} with an example.",
    "What are advantages of {X}?",
    "What is the difference between {X} and {Y}?",
    "When should we use {X}?",
    "Describe the working of {X}.",
    "What problem does {X} solve?",
    "List common use-cases of {X}.",
    "What are the types of {X}?",
    "Explain {X} step-by-step."
]

# Keywords per subject (short lists; extend as needed)
KEYWORDS = {
    "DBMS": ["Normalization", "1NF", "2NF", "3NF", "Transaction", "ACID", "Index", "Join", "Primary key", "Foreign key", "Denormalization", "SQL", "Query", "View", "Stored procedure", "Trigger", "ACID", "Concurrency", "Locking", "Deadlock"],
    "CN": ["TCP", "UDP", "IP address", "Subnetting", "Routing", "Switch", "Hub", "DNS", "OSI model", "TCP/IP", "ARP", "MAC address", "Firewall", "NAT", "HTTP", "HTTPS", "SSL/TLS", "Socket", "Packet", "Bandwidth"],
    "OS": ["Process", "Thread", "Scheduling", "Paging", "Virtual memory", "Deadlock", "Semaphore", "Mutex", "Context switch", "File system", "Interrupt", "IO", "Kernel", "Bootloader", "Swap"],
    "DSA": ["Binary search", "QuickSort", "MergeSort", "Heap", "Stack", "Queue", "Linked list", "BST", "Dijkstra", "Dynamic programming", "Greedy", "Recursion", "Hashing", "Graph", "BFS", "DFS"],
    "OOP": ["Encapsulation", "Inheritance", "Polymorphism", "Abstraction", "SOLID", "Interface", "Abstract class", "Constructor", "Overloading", "Overriding", "UML", "Design pattern", "Singleton"],
    "SE": ["SDLC", "Agile", "Waterfall", "UML", "Use case", "Requirement", "Testing", "Unit test", "Integration test", "Version control", "CI/CD", "Design pattern", "Code review"]
}

# Simple short answer maker (placeholder). For a full app you may expand these mappings or edit manually.
SHORT_ANSWERS = {
    "Normalization": "Process of organizing data to reduce redundancy.",
    "1NF": "First Normal Form: atomic attribute values and no repeating groups.",
    "2NF": "Second Normal Form: 1NF + no partial dependencies on composite keys.",
    "3NF": "Third Normal Form: 2NF + no transitive dependencies.",
    "Transaction": "A unit of work that is atomic, consistent, isolated and durable (ACID).",
    "ACID": "Atomicity, Consistency, Isolation, Durability.",
    "Index": "Structure to speed up lookups using trees or hashes.",
    "Join": "Combine rows from two or more tables based on related columns.",
    "Binary search": "Divide and conquer search with O(log n) complexity.",
    "QuickSort": "Divide and conquer sorting with average O(n log n).",
    "Process": "Program in execution with its own memory and resources.",
    "Thread": "Lightweight execution unit within a process sharing memory.",
    "Encapsulation": "Wrapping data and methods inside a single unit/class.",
    "Inheritance": "Deriving new classes from existing ones to reuse code.",
    "Polymorphism": "Ability of objects to take multiple forms via overriding/overloading.",
    "SDLC": "Software Development Life Cycle: requirement to maintenance phases."
}

def make_answer(keyword):
    return SHORT_ANSWERS.get(keyword, f"Short explanation of {keyword}.")

def generate_for_subject(subject, count=50):
    items = []
    keys = KEYWORDS.get(subject, [])
    for i in range(count):
        tpl = random.choice(TEMPLATES)
        if "{Y}" in tpl:
            x = random.choice(keys)
            y = random.choice([k for k in keys if k != x])
            q = tpl.format(X=x, Y=y)
            a = make_answer(x) + " vs " + make_answer(y)
        else:
            x = random.choice(keys)
            q = tpl.format(X=x)
            a = make_answer(x)
        items.append({"topic": "AutoGen", "question": q, "answer": a})
    return items

def generate_all(subjects, per_subject=50):
    out = {}
    for s in subjects:
        out[s] = generate_for_subject(s, per_subject)
    return out

if __name__ == "__main__":
    subjects = ["DBMS","CN","OS","DSA","OOP","SE"]
    data = generate_all(subjects, per_subject=50)
    with open("generated_questions.json","w") as f:
        json.dump(data, f, indent=2)
    print("generated_questions.json created with", sum(len(v) for v in data.values()), "questions.")
