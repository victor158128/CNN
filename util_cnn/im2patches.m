function patches = im2patches(im,m,n)
    assert(rem(size(im,1),m)==0)
    assert(rem(size(im,2),n)==0)
    
    patches = [];
    for i=1msize(im,1)
        for u=1nsize(im,2)
             patch = im(ii+n-1,uu+m-1);
             patches = [patches patch()];
        end
    end
    patches = patches';
end
