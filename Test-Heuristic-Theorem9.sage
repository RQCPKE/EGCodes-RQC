######## Test Heuristic  Argument in Theorem 9 (Page 36) for weight w < r #############

def random_small_vector_genenration(Extension, Length, Weight):
    B = matrix(Fqm.base_ring(), Weight, Extension, 0)
    while B.rank() != Weight:
        B = random_matrix(Fqm.base_ring(),Weight, Extension)
    C = matrix(Fqm.base_ring(), Length, Extension,0)
    while C.rank() != Weight:
        C = random_matrix(Fqm.base_ring(), Length, Weight) * B
    return vector(Fqm,[C[i] for i in range(Length)])

def random_small_rank_matrix_genenration(Rows, Cloumns, Rank):
    B = matrix(Fqm.base_ring(), Rank, Cloumns, 0)
    while B.rank() != Rank:
        B = random_matrix(Fqm.base_ring(),Rank, Cloumns)
    C = matrix(Fqm.base_ring(), Rows, Rank,0)
    while C.rank() != Rank:
        C = random_matrix(Fqm.base_ring(), Rows, Rank) * B
    return C


def Frob_Map(element,degree):
    a = element
    if degree == 0:
        Identity = Frob.inverse() * Frob
        a = Identity(a)
    if degree > 0:
        for i in range(degree):
            a = Frob(a)
    if degree < 0:
        InverseFrob = Frob.inverse()
        for i in range(-degree):
            a = InverseFrob(a)
    return a


def Frob_vector(vectors,degrees):
    lengths = len(list(vectors))
    Frob_vector = vector(Fqm, lengths, [Frob_Map(vectors[i], degrees) for i in range(lengths)])
    return Frob_vector

def Moore_matrix(vectors,rows):
    List = []; columns = len(list(vectors))
    for i in range(rows):
        List.append(Frob_vector(vectors,i))
    return matrix(Fqm, rows, columns, List)

def test(totalltests):
    succ = 0
    failure = 0
    for npair in range(totalltests):
        M = random_small_rank_matrix_genenration(t+w, n, TestRank)
        B = L * M
        try:
            if B.rank() == TestRank: 
                succ += 1
            else:
                failure += 1
        except:
            print("Unexpected error", sys.exc_info()[0])
            
    print ("success/totalltests: %d/%d; success rate: %f" % (succ,totalltests,succ/totalltests))
    print ("failure/totalltests: %d/%d; failure rate: %f" % (failure,totalltests,failure/totalltests))
    

# t = |g|
# t >= k + r  
# n >= k + 2r 
# Ensure the Rank of n * (k + 2r + 1) to be  k+2r 
#  r <= min(n-k/2,m-k)    

#(q,m,n,t, k,r,w) = (2,53,89,53,5,36,7)  
(q,m,n,t,k,r,w) = (2,10,20,10,2,8,4)

Fqm.<a> = GF(q**m)
Frob = Fqm.frobenius_endomorphism()
S = OrePolynomialRing(Fqm, Frob, 'x')
# S.<x> = Fqm['x', Frob]

     
g = random_small_vector_genenration(m, t, t) 
e = random_small_vector_genenration(m, w, w)   
L = block_diagonal_matrix(Moore_matrix(e, r+1), Moore_matrix(g, k+r))
TestRank = k + r + w

%time test(100000)
